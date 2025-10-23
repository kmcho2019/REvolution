module TopModule (
    input clk,
    input in,
    output out
);

    wire d_input;
    wire q_output;

    assign d_input = in ^ q_output;
    assign out = q_output;

    dff d_flip_flop (
        .clk(clk),
        .d(d_input),
        .q(q_output)
    );

endmodule

module dff (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule