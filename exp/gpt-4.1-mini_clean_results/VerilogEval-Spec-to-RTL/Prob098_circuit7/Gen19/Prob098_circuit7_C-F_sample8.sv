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
    // Invert input 'a' combinationally before feeding into DFF
    wire d_in = ~a;

    DFF dff_inst (
        .clk(clk),
        .d(d_in),
        .q(q)
    );
endmodule