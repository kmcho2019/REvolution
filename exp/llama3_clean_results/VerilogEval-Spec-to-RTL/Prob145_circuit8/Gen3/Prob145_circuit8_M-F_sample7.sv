module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock or negedge clock) begin
    if (clock == 1'b1) begin // Positive edge
        p <= a; // Set 'p' to 'a' at positive edge
        if (p == 1'b1) begin
            q <= 1'b1; // Set 'q' if 'p' is set
        end
    end else if (a == 1'b1) begin // Negative edge and 'a' is high
        p <= 1'b0; // Reset 'p' and 'q' to 0
        q <= 1'b0;
    end
end

endmodule