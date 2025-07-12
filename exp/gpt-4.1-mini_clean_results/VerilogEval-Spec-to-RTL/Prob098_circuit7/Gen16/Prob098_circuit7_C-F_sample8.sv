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
    input a,
    output q
);
    wire a_inv;

    // Explicit combinational inversion
    assign a_inv = ~a;

    // Instantiate the flip-flop with the inverted input
    DFF dff_inst (
        .clk(clk),
        .d(a_inv),
        .q(q)
    );
endmodule