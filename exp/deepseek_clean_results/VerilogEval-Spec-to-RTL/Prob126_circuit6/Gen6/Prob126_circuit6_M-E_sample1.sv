module TopModule (
    input [2:0] a,
    output [15:0] q
);

wire [7:0] upper = (a * 8'h37) ^ 8'hAA;
wire [7:0] lower = (a * 8'h42) ^ 8'h55;

assign q = {upper, lower};

endmodule