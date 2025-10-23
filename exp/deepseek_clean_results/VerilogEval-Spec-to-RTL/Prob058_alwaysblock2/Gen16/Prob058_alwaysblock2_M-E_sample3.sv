module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    // Sequential XOR output (standard implementation)
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

    // Combinational outputs with sequential feedback
    assign out_assign = (a ^ b) ^ out_always_ff;
    
    always @(*) begin
        out_always_comb = (a ^ b) ^ out_always_ff;
    end

endmodule