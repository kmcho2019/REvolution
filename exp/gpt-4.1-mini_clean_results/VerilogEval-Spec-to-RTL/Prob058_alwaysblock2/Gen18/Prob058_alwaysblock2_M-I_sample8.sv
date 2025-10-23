module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    // Shared behavioral XOR wire
    wire xor_behavioral;
    assign xor_behavioral = a ^ b;

    // Assign output driven by behavioral XOR expression
    assign out_assign = xor_behavioral;

    // Combinational always block uses shared behavioral XOR output
    always @(*) begin
        out_always_comb = xor_behavioral;
    end

    // Sequential always block registers XOR on posedge clk with nonblocking assignment
    always @(posedge clk) begin
        out_always_ff <= a ^ b; // direct behavioral expression
    end

endmodule