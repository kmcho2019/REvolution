module TopModule(
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);

reg [2:0] input_signals;
reg [3:0] output_signals;

always @(*) begin
    input_signals = {a, b, c};
    output_signals[0] = input_signals[2]; // a -> w
    output_signals[1] = input_signals[1]; // b -> x
    output_signals[2] = input_signals[1]; // b -> y
    output_signals[3] = input_signals[0]; // c -> z
    assign w = output_signals[0];
    assign x = output_signals[1];
    assign y = output_signals[2];
    assign z = output_signals[3];
end

endmodule