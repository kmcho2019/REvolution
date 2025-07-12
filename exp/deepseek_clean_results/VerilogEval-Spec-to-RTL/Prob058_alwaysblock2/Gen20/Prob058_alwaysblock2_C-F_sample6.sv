module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    // Simplest continuous assignment
    assign out_assign = a ^ b;

    // Modern combinational block
    always_comb begin
        out_always_comb = a ^ b;
    end

    // Clear sequential implementation
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule