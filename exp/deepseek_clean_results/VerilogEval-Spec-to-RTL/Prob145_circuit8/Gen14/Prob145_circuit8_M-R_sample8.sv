module TopModule (
    input clock,
    input a,
    output p,
    output q
);

reg p_reg, q_reg;
reg seen_p;  // Tracks if p was high for full cycle

// p generation (synchronous)
always @(posedge clock) begin
    if (!q_reg) begin
        p_reg <= a;
    end else begin
        p_reg <= 0;
    end
end

// q generation and seen_p tracking
always @(posedge clock, negedge clock) begin
    if (posedge clock) begin
        // Set q if we saw p high for full cycle
        if (seen_p) begin
            q_reg <= 1;
        end
    end
    else if (negedge clock) begin
        // Reset condition
        if (a) begin
            q_reg <= 0;
            seen_p <= 0;
        end
        // Track if p was high at falling edge
        else if (p_reg) begin
            seen_p <= 1;
        end
    end
end

// Continuous assignments
assign p = p_reg;
assign q = q_reg;

initial begin
    p_reg = 0;
    q_reg = 0;
    seen_p = 0;
end

endmodule