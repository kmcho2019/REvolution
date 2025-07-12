module TopModule(
    output wire out
);

wire constant_net;
assign constant_net = 1'b0;
assign out = constant_net;

endmodule