module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states
reg A, B, C, D;

// Combinational logic for next state
assign A_next = (A && !in) || (C && !in);
assign B_next = (A && in) || (B && in) || (D && in);
assign C_next = (B && !in) || (D && !in);
assign D_next = (C && in);

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        A <= 1'b1;
        B <= 1'b0;
        C <= 1'b0;
        D <= 1'b0;
    end else begin
        A <= A_next;
        B <= B_next;
        C <= C_next;
        D <= D_next;
    end
end

// Output logic
assign out = D;

endmodule