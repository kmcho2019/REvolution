module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot state encoding: A=0001, B=0010, C=0100, D=1000
    reg A, B, C, D;

    // Next state logic
    wire next_A = (A & ~in) | (C & ~in);
    wire next_B = (A & in) | (B & in) | (D & in);
    wire next_C = (B & ~in) | (D & ~in);
    wire next_D = (C & in);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            A <= 1'b1;
            B <= 1'b0;
            C <= 1'b0;
            D <= 1'b0;
        end else begin
            A <= next_A;
            B <= next_B;
            C <= next_C;
            D <= next_D;
        end
    end

    // Output is directly the D state
    assign out = D;

endmodule