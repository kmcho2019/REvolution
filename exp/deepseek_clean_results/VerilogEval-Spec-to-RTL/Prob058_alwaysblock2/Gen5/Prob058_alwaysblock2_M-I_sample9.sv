module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output reg  out_always_ff
);

    // Continuous assignment and combinational always block share the same XOR
    assign out_assign = a ^ b;
    assign out_always_comb = a ^ b;
    
    // Sequential implementation
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule