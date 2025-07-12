module TopModule #(
    parameter USE_XOR = 0
) (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    wire feedback;
    
    // Conditional XOR for bit 0, direct feedthrough for others
    assign feedback = USE_XOR ? (q_in ^ r_in) : q_in;

    always @(posedge clk) begin
        Q <= L ? r_in : feedback;
    end

endmodule