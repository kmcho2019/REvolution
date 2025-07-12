module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    // Shared XOR computation with explicit wire declaration
    wire xor_result = a ^ b;
    
    // Continuous assignment (simplest form)
    assign out_assign = xor_result;
    
    // Combinational always block (explicit intent)
    always @(*) begin
        out_always_comb = xor_result;
    end
    
    // Sequential always block (clean implementation)
    always @(posedge clk) begin
        out_always_ff <= xor_result;
    end

endmodule