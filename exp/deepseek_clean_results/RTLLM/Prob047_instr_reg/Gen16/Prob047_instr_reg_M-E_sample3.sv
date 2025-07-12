module instr_reg (
    input clk,
    input rst_n,  // Active low reset
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // Pipeline registers with validity flags
    reg [7:0] ins_p1, ins_p2;
    reg valid_p1, valid_p2;
    reg [7:0] ins_p1_stage2, ins_p2_stage2;
    
    // Clock gating signals
    wire clk_gated = clk & (|fetch);
    wire clk_p1 = clk & fetch[0];
    wire clk_p2 = clk & fetch[1];
    
    // Error detection
    wire fetch_error = (fetch == 2'b11);
    
    // First pipeline stage - capture
    always @(posedge clk_p1 or negedge rst_n) begin
        if (!rst_n) begin
            ins_p1 <= 8'b0;
            valid_p1 <= 1'b0;
        end else begin
            ins_p1 <= data;
            valid_p1 <= 1'b1;
        end
    end
    
    always @(posedge clk_p2 or negedge rst_n) begin
        if (!rst_n) begin
            ins_p2 <= 8'b0;
            valid_p2 <= 1'b0;
        end else begin
            ins_p2 <= data;
            valid_p2 <= 1'b1;
        end
    end
    
    // Second pipeline stage - output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ins_p1_stage2 <= 8'b0;
            ins_p2_stage2 <= 8'b0;
            ins <= 3'b0;
            ad1 <= 5'b0;
            ad2 <= 8'b0;
        end else begin
            // Only update outputs when valid
            if (valid_p1) begin
                ins_p1_stage2 <= ins_p1;
                ins <= ins_p1[7:5];
                ad1 <= ins_p1[4:0];
            end
            
            if (valid_p2) begin
                ins_p2_stage2 <= ins_p2;
                ad2 <= ins_p2;
            end
            
            // Clear validity flags after use
            valid_p1 <= 1'b0;
            valid_p2 <= 1'b0;
        end
    end

endmodule