module instr_reg(
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

reg [7:0] ins_p1; // Register to store the first part of the instruction
reg [7:0] ins_p2; // Register to store the second part of the instruction

always @(posedge clk or negedge rst) begin
    if (!rst) begin // Active low reset
        ins_p1 <= 8'd0; // Initialize ins_p1 to zero on reset
        ins_p2 <= 8'd0; // Initialize ins_p2 to zero on reset
    end else begin
        case (fetch)
            2'b01: ins_p1 <= data; // If fetch is 2'b01, load data into ins_p1
            2'b10: ins_p2 <= data; // If fetch is 2'b10, load data into ins_p2
            default: ; // If neither condition is met, retain previous values
        endcase
    end
end

// Derive outputs from the stored instructions
assign ins = ins_p1[7:5]; // High 3 bits of the instruction in ins_p1
assign ad1 = ins_p1[4:0]; // Low 5 bits of the instruction in ins_p1
assign ad2 = ins_p2; // Full 8-bit data from ins_p2

endmodule