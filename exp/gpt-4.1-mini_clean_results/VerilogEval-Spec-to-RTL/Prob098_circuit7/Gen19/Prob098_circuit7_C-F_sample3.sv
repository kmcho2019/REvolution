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
    // Explicit combinational inversion of input 'a'
    wire a_inv;
    assign a_inv = ~a;

    // Register the inverted input on rising edge of clk
    DFF dff_inst (
        .clk(clk),
        .d(a_inv),
        .q(q)
    );
endmodule