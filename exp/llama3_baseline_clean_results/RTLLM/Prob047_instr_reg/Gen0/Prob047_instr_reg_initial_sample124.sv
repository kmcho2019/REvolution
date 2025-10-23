module instr_reg(
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

reg [7:0] ins_p1; // first 8-bit register to store instructions
reg [7:0] ins_p2; // second 8-bit register to store instructions

always @ (posedge clk or negedge rst) begin
    if (~rst) begin
        // reset both registers to zero when reset signal is low
        ins_p1 <= 8'd0;
        ins_p2 <= 8'd0;
    end
    else begin
        case (fetch)
            2'b01: begin
                // fetch instruction from data input into ins_p1
                ins_p1 <= data;
                ins_p2 <= ins_p2; // retain previous value in ins_p2
            end
            2'b10: begin
                // fetch instruction from data input into ins_p2
                ins_p1 <= ins_p1; // retain previous value in ins_p1
                ins_p2 <= data;
            end
            default: begin
                // retain previous values in both registers
                ins_p1 <= ins_p1;
                ins_p2 <= ins_p2;
            end
        endcase
    end
end

// derive output signals from stored instructions
assign ins = ins_p1[7:5]; // high 3 bits of ins_p1
assign ad1 = ins_p1[4:0]; // low 5 bits of ins_p1
assign ad2 = ins_p2; // full 8-bit data from ins_p2

endmodule