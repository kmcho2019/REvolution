module DFF (
    input  wire clk,
    input  wire d,
    output reg  q
);

    always @(posedge clk) begin
        q <= d;
    end

endmodule

module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output wire out_always_ff
);

    wire xor_result;
    
    assign xor_result = a ^ b;
    assign out_assign = xor_result;
    assign out_always_comb = xor_result;
    
    DFF dff_inst (
        .clk(clk),
        .d(xor_result),
        .q(out_always_ff)
    );

endmodule