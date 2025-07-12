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

    // Pattern History Table
    reg [1:0] pht [0:127];
    
    // Global History Register
    reg [6:0] ghr;

    // Prediction path (combinational)
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];  // MSB determines prediction
    assign predict_history = ghr;

    // Training path
    wire [6:0] train_index = train_pc ^ train_history;
    
    // Next counter state calculation
    function [1:0] next_counter;
        input [1:0] current;
        input taken;
        begin
            case (current)
                2'b00: next_counter = taken ? 2'b01 : 2'b00;
                2'b01: next_counter = taken ? 2'b10 : 2'b00;
                2'b10: next_counter = taken ? 2'b11 : 2'b01;
                2'b11: next_counter = taken ? 2'b11 : 2'b10;
            endcase
        end
    endfunction

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly taken (2'b10)
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b10;
            end
            ghr <= 7'b0;
        end else begin
            // Handle training updates first
            if (train_valid) begin
                // Update PHT on next cycle
                pht[train_index] <= next_counter(pht[train_index], train_taken);
                
                // Update GHR - mispredictions restore history
                if (train_mispredicted) begin
                    ghr <= {train_history[5:0], train_taken};
                end else begin
                    ghr <= {ghr[5:0], train_taken};
                end
            end 
            // Then handle prediction updates if no training
            else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule