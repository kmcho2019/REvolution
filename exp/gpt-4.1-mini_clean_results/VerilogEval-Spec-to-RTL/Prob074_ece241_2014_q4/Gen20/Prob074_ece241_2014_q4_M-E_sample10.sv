module TopModule (
    input  clk,
    input  rst,
    input  x,
    output z
);

    reg xor_ff, and_ff, or_ff;
    wire d_xor, d_and, d_or;

    // Combinational logic for D inputs of flip-flops
    assign d_xor = x ^ xor_ff;       // XOR gate: x and XOR flip-flop output
    assign d_and = x & ~and_ff;      // AND gate: x and complemented AND flip-flop output
    assign d_or  = x | ~or_ff;       // OR gate: x and complemented OR flip-flop output

    // Flip-flops with asynchronous active-high reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            xor_ff <= 1'b0;
            and_ff <= 1'b0;
            or_ff  <= 1'b0;
        end else begin
            xor_ff <= d_xor;
            and_ff <= d_and;
            or_ff  <= d_or;
        end
    end

    // Output z is NOR of all three flip-flop outputs
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule