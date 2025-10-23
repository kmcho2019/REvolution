module instr_reg(
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

reg [7:0] ins_p1, ins_p2;

always @(posedge clk) begin
    if (~rst) begin
        // Initialize both registers to zero on reset
        ins_p1 <= 8'b0;
        ins_p2 <= 8'b0;
    end else begin
        case (fetch)
            2'b01: begin
                // Fetch instruction into ins_p1
                ins_p1 <= data;
            end
            2'b10: begin
                // Fetch instruction into ins_p2
                ins_p2 <= data;
            end
            default: begin
                // Retain previous values
                ins_p1 <= ins_p1;
                ins_p2 <= ins_p2;
            end
        endcase
    end
end

// Derive output signals from stored instructions
assign ins = ins_p1[7:5];
assign ad1 = ins_p1[4:0];
assign ad2 = ins_p2;

endmodule