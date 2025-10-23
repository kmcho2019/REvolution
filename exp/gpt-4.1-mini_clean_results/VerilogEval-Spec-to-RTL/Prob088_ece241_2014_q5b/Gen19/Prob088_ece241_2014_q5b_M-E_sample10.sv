module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

reg state_A, state_B;
reg next_A, next_B;

// Next state logic
always @(*) begin
    // Default to no change
    next_A = state_A;
    next_B = state_B;

    if (state_A) begin
        if (x)
            begin
                next_A = 1'b0;
                next_B = 1'b1;
            end
        else
            begin
                next_A = 1'b1;
                next_B = 1'b0;
            end
    end else if (state_B) begin
        next_A = 1'b0;
        next_B = 1'b1;
    end else begin
        // Should not happen; default to A
        next_A = 1'b1;
        next_B = 1'b0;
    end
end

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;
        state_B <= 1'b0;
    end else begin
        state_A <= next_A;
        state_B <= next_B;
    end
end

// Output logic (Mealy): z=1 if (in A and x=1) or (in B and x=0)
assign z = (state_A & x) | (state_B & ~x);

endmodule