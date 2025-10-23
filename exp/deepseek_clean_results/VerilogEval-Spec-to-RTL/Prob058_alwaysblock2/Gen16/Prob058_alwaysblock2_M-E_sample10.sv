module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Implementation 1: XOR using basic gates (alternative to ^ operator)
    wire a_and_notb = a & ~b;
    wire not_a_and_b = ~a & b;
    assign out_assign = a_and_notb | not_a_and_b;

    // Implementation 2: MUX-based XOR
    always @(*) begin
        out_always_comb = b ? ~a : a;
    end

    // Implementation 3: State machine based sequential XOR
    reg last_a, last_b;
    always @(posedge clk) begin
        if (a != last_a || b != last_b) begin
            out_always_ff <= a ^ b;
            last_a <= a;
            last_b <= b;
        end
    end

endmodule