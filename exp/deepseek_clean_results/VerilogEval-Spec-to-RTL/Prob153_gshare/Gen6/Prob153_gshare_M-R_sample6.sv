module TopModule (
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    // Function for saturating counter increment
    function [1:0] inc_counter(input [1:0] cnt);
        inc_counter = (cnt == 2'b11) ? 2'b11 : cnt + 1;
    endfunction

    // Function for saturating counter decrement
    function [1:0] dec_counter(input [1:0] cnt);
        dec_counter = (cnt == 2'b00) ? 2'b00 : cnt - 1;
    endfunction

    // 7-bit global history register
    reg [6:0] ghr;
    // 128-entry pattern history table (2-bit saturating counters)
    reg [1:0] pht [0:127];

    // Prediction index calculation
    wire [6:0] predict_index = predict_pc ^ ghr;
    
    // Prediction outputs
    assign predict_taken = pht[predict_index][1];  // MSB determines prediction
    assign predict_history = ghr;

    // Training index calculation
    wire [6:0] train_index = train_pc ^ train_history;

    // PHT update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset PHT
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else if (train_valid) begin
            // Update PHT counter based on training
            if (train_taken) begin
                pht[train_index] <= inc_counter(pht[train_index]);
            end else begin
                pht[train_index] <= dec_counter(pht[train_index]);
            end
        end
    end

    // GHR update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
        end else begin
            // Training has priority over prediction
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule