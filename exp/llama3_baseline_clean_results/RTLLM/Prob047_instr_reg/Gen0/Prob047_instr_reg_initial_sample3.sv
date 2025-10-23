module instr_reg(
    input clk,
    input rst_n,  // Active low reset
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

reg [7:0] ins_p1;  // Register to store instruction from first source
reg [7:0] ins_p2;  // Register to store instruction from second source

always @(posedge clk) begin
    if (~rst_n) begin  // If reset is low, initialize registers to zero
        ins_p1 <= 8'd0;
        ins_p2 <= 8'd0;
    end else begin
        case (fetch)
            2'b01: ins_p1 <= data;  // If fetch is 2'b01, load instruction into ins_p1
            2'b10: ins_p2 <= data;  // If fetch is 2'b10, load instruction into ins_p2
            default: begin  // If neither condition is met, retain previous values
                ins_p1 <= ins_p1;
                ins_p2 <= ins_p2;
            end
        endcase
    end
end

// Derive output ports from stored instructions
assign ins = ins_p1[7:5];  // High 3 bits of the instruction
assign ad1 = ins_p1[4:0];  // Low 5 bits of the instruction
assign ad2 = ins_p2;      // Full 8-bit data from the second source

endmodule