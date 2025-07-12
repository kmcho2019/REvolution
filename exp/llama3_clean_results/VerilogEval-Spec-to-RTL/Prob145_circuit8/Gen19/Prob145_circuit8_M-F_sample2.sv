module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_prev; // To store the previous value of 'a'

always @(posedge clock) begin
    if (a) begin // 'a' is high
        p <= 1'b1; // Set 'p' high
        if (a_prev) begin // 'a' has been high for at least one previous clock cycle
            q <= 1'b1; // Set 'q' high
        end else begin
            q <= 1'b0; // 'q' remains low
        end
    end else begin // 'a' is low
        p <= 1'b0; // Reset 'p'
        q <= 1'b0; // Reset 'q'
    end
    a_prev <= a; // Update the previous value of 'a' after evaluating the current state
end

always @(negedge clock) begin
    if (!a && q) begin // 'a' is low and 'q' is high
        q <= 1'b1; // Keep 'q' high
    end else if (a) begin // 'a' is high
        q <= 1'b0; // Reset 'q'
    end
end

endmodule