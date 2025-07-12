module TopModule(
    output out
);

wire dummy_input;
assign dummy_input = 1'b0;
assign out = dummy_input & 1'b1;

endmodule