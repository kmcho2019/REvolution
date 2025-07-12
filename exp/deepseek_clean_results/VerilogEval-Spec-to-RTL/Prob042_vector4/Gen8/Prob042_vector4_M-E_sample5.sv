module TopModule (
    input [7:0] in,
    output [31:0] out
);
    wire [31:0] extended;
    assign extended = {24'b0, in};
    assign out = (extended << 24) >>> 24;
endmodule