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
    wire d = ~a;  // explicit combinational inversion outside flip-flop

    DFF dff_inst (
        .clk(clk),
        .d(d),
        .q(q)
    );
endmodule