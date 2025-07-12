module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output reg  out_always_ff = 1'b0
);

    // Continuous assignment
    assign out_assign = a ^ b;
    
    // Combinational always block
    assign out_always_comb = a ^ b;

    // Sequential implementation
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule