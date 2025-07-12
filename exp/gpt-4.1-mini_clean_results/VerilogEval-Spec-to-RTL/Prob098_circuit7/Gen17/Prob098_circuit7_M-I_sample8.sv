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
    wire a_inv = ~a;  // invert input explicitly

    DFF dff_inst (
        .clk(clk),
        .d(a_inv),
        .q(q)
    );
endmodule