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

    // 7-bit global history register
    reg [6:0] ghr;
    reg [6:0] ghr_pred;  // GHR value used for prediction
    // 128-entry pattern history table (2-bit saturating counters)
    reg [1:0] pht [0:127];

    // Prediction logic
    wire [6:0] predict_index = predict_pc ^ ghr_pred;
    assign predict_taken = predict_valid ? pht[predict_index][1] : 1'b0;
    assign predict_history = ghr_pred;

    // Training logic
    wire [6:0] train_index = train_pc ^ train_history;
    wire [1:0] current_counter = pht[train_index];
    wire [1:0] new_counter;

    // 2-bit saturating counter update logic
    assign new_counter = train_taken ? 
                         (current_counter == 2'b11 ? 2'b11 : current_counter + 1) :
                         (current_counter == 2'b00 ? 2'b00 : current_counter - 1);

    // Update logic for GHR and PHT
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            ghr_pred <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly taken initial state
            end
        end else begin
            // Capture GHR used for prediction
            if (predict_valid) begin
                ghr_pred <= ghr;
            end

            // Training has priority over prediction updates
            if (train_valid) begin
                // Update PHT
                pht[train_index] <= new_counter;
                
                // Update GHR if mispredicted (recover) or normal training
                if (train_mispredicted) begin
                    ghr <= {train_history[5:0], train_taken};
                end else begin
                    ghr <= {ghr[5:0], train_taken};
                end
            end else if (predict_valid) begin
                // Only update GHR for predictions when not training
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule