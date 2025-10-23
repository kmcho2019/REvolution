module DFF (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input clk,
    input in,
    output out
);
    wire d_input;
    wire q_output;

    assign d_input = in ^ q_output;  // XOR of input and flip-flop output

    DFF dff_inst (
        .clk(clk),
        .d(d_input),
        .q(q_output)
    );

    assign out = q_output;

endmodule