module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

reg [7:0] ins_p1;
reg [7:0] ins_p2;

// Using non-blocking assignments for clarity and to follow best practices in sequential logic
always @(posedge clk or negedge rst) begin
    if (~rst) begin
        ins_p1 <= 8'd0;
        ins_p2 <= 8'd0;
    end else if (fetch == 2'b01) begin
        ins_p1 <= data;
    end else if (fetch == 2'b10) begin
        ins_p2 <= data;
    end
end

// Continuous assignments for output derivation, directly mapping ins_p1 and ins_p2 to outputs
assign ins = ins_p1[7:5];
assign ad1 = ins_p1[4:0];
assign ad2 = ins_p2;

endmodule