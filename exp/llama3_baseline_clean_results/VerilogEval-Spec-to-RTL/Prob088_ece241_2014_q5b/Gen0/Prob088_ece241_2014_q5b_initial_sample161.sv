module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg A, B; // One-hot encoding for states
reg A_next, B_next; // Next state registers

// Combinational logic for next states
always @(*) begin
    if (areset) begin
        A_next = 1;
        B_next = 0;
    end else begin
        if (A && !x) begin
            A_next = 1;
            B_next = 0;
        end else if (A && x) begin
            A_next = 0;
            B_next = 1;
        end else if (B) begin
            A_next = 0;
            B_next = 1; // State B remains the same regardless of x
        end
    end
end

// Combinational logic for output z
always @(*) begin
    if (A && !x) begin
        z = 0;
    end else if (A && x) begin
        z = 1;
    end else if (B) begin
        // For state B, z is the inverse of x (based on the 2's complement behavior described)
        z = ~x;
    end
end

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        A <= 1;
        B <= 0;
    end else begin
        A <= A_next;
        B <= B_next;
    end
end

endmodule