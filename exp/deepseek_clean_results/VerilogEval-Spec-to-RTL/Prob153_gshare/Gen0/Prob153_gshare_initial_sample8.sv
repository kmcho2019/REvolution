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

    // Pattern History Table (128 entries of 2-bit saturating counters)
    reg [1:0] pht [0:127];
    
    // Global History Register
    reg [6:0] ghr;
    
    // Prediction index (XOR of PC and GHR)
    wire [6:0] predict_index = predict_pc ^ ghr;
    
    // Training index (XOR of PC and train_history)
    wire [6:0] train_index = train_pc ^ train_history;
    
    // PHT read for prediction
    assign predict_taken = pht[predict_index][1]; // MSB determines prediction
    assign predict_history = ghr;
    
    // Initialize PHT to weakly taken (01)
    integer i;
    initial begin
        for (i = 0; i < 128; i = i + 1)
            pht[i] = 2'b01;
    end
    
    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            // Reset PHT to weakly taken
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
        end else begin
            // Training takes precedence over prediction
            if (train_valid) begin
                // Update PHT based on actual branch outcome
                case (pht[train_index])
                    2'b00: pht[train_index] <= train_taken ? 2'b01 : 2'b00;
                    2'b01: pht[train_index] <= train_taken ? 2'b10 : 2'b00;
                    2'b10: pht[train_index] <= train_taken ? 2'b11 : 2'b01;
                    2'b11: pht[train_index] <= train_taken ? 2'b11 : 2'b10;
                endcase
                
                // On misprediction, recover GHR to train_history
                if (train_mispredicted) begin
                    ghr <= {train_history[5:0], train_taken};
                end
            end else if (predict_valid) begin
                // Update GHR with prediction (shift left and add prediction)
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule