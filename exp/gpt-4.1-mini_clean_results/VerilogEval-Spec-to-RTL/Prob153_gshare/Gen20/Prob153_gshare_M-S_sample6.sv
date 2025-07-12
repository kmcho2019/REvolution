module TopModule(
    input         clk,
    input         areset,

    // Prediction interface
    input         predict_valid,
    input  [6:0]  predict_pc,
    output        predict_taken,
    output [6:0]  predict_history,

    // Training interface
    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]  train_history,
    input  [6:0]  train_pc
);

    reg [1:0] pht [0:127];
    reg [6:0] fetch_ghr, train_ghr;

    // Index calculation
    wire [6:0] predict_index = predict_pc ^ fetch_ghr;
    wire [1:0] predict_counter = pht[predict_index];
    wire       predicted_taken = predict_counter[1];

    wire [6:0] train_index = train_pc ^ train_history;

    assign predict_taken = predicted_taken;
    assign predict_history = fetch_ghr;

    // Saturating counter update function
    function [1:0] sat_update;
        input [1:0] curr;
        input       taken;
        begin
            if (taken) sat_update = (curr == 2'b11) ? 2'b11 : curr + 1;
            else        sat_update = (curr == 2'b00) ? 2'b00 : curr - 1;
        end
    endfunction

    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01; // weakly not taken
            fetch_ghr <= 0;
            train_ghr <= 0;
        end else begin
            // Update PHT and train_ghr if training valid
            if (train_valid) begin
                // Update saturating counter at train index
                pht[train_index] <= sat_update(pht[train_index], train_taken);

                if (train_mispredicted) begin
                    // Flush: recover histories
                    train_ghr <= train_history;
                    fetch_ghr <= train_history;
                end else begin
                    train_ghr <= {train_ghr[5:0], train_taken};
                    // Update fetch_ghr only if no flush and prediction valid later
                end
            end

            // If no flush this cycle, update fetch_ghr if prediction valid
            if (!(train_valid && train_mispredicted) && predict_valid) begin
                fetch_ghr <= {fetch_ghr[5:0], predicted_taken};
            end
            // Else fetch_ghr remains unchanged
        end
    end

endmodule