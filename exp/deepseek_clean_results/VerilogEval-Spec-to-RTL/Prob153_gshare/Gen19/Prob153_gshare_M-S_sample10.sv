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

    // Pattern History Table (128 entries)
    reg [1:0] pht [0:127];
    
    // Global History Register
    reg [6:0] ghr;
    
    // Prediction outputs
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = predict_valid ? pht[predict_index][1] : 1'b0;
    assign predict_history = ghr;
    
    // Sequential updates
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly taken (2'b01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
            ghr <= 7'b0;
        end else begin
            // Update PHT if training
            if (train_valid) begin
                case (pht[train_pc ^ train_history])
                    2'b00: pht[train_pc ^ train_history] <= train_taken ? 2'b01 : 2'b00;
                    2'b01: pht[train_pc ^ train_history] <= train_taken ? 2'b10 : 2'b00;
                    2'b10: pht[train_pc ^ train_history] <= train_taken ? 2'b11 : 2'b01;
                    2'b11: pht[train_pc ^ train_history] <= train_taken ? 2'b11 : 2'b10;
                endcase
            end
            
            // Update GHR with priority to training
            if (train_valid && train_mispredicted)
                ghr <= {train_history[5:0], train_taken};
            else if (predict_valid)
                ghr <= {ghr[5:0], predict_taken};
        end
    end

endmodule