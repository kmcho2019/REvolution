module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    // Continuous assignment implementation
    assign out_assign = a ^ b;

    // Combinational always block implementation
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Sequential implementation with explicit combinational logic
    wire xor_ab;
    assign xor_ab = a ^ b;
    
    always @(posedge clk) begin
        out_always_ff <= xor_ab;
    end

endmodule