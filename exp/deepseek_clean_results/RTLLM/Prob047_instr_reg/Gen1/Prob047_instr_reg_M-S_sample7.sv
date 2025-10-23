module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // Internal registers to store instructions from different sources
    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Active low reset clears both registers and outputs
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
            ins <= 3'b0;
            ad1 <= 5'b0;
            ad2 <= 8'b0;
        end
        else begin
            // Update registers based on fetch signal
            case (fetch)
                2'b01: ins_p1 <= data;  // Store in first register
                2'b10: ins_p2 <= data;  // Store in second register
            endcase
            
            // Update outputs in same clock cycle
            ins <= ins_p1[7:5];  // Upper 3 bits of first register
            ad1 <= ins_p1[4:0];   // Lower 5 bits of first register
            ad2 <= ins_p2;        // Full second register
        end
    end

endmodule