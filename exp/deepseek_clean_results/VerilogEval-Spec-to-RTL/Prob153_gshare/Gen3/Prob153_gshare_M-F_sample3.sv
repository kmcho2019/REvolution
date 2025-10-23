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
    // 128-entry pattern history table (2-bit saturating counters)
    reg [1:0] pht [0:127];

    // Prediction index calculation
    wire [6:0] predict_index = predict_pc ^ ghr;

    // Training index calculation
    wire [6:0] train_index = train_pc ^ train_history;

    // PHT update logic
    wire [1:0] current_counter = pht[train_index];
    wire [1:0] new_counter;

    // 2-bit saturating counter update
    assign new_counter = train_taken ? 
                        (current_counter == 2'b11 ? 2'b11 : current_counter + 1) :
                        (current_counter == 2'b00 ? 2'b00 : current_counter - 1);

    // Prediction outputs (combinational)
    assign predict_taken = predict_valid ? pht[predict_index][1] : 1'b0;
    assign predict_history = ghr;

    // GHR and PHT update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly taken initial state
            end
        end else begin
            // Handle training first (has priority)
            if (train_valid) begin
                // Update PHT
                pht[train_index] <= new_counter;
                
                // Update GHR - recover history if mispredicted
                if (train_mispredicted) begin
                    ghr <= {train_history[5:0], train_taken};
                end else begin
                    ghr <= {ghr[5:0], train_taken};
                end
            end 
            // Then handle prediction updates (only if no training)
            else if (predict_valid) begin
                ghr <= {ghr[5:0], pht[predict_index][1]};
            end
        end
    end

endmodule