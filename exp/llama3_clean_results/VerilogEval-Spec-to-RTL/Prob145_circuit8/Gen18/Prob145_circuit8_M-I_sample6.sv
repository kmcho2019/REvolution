module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a; // To store the previous value of 'a'

always @(posedge clock) begin
    prev_a <= a; // Update the previous value of 'a'
    p <= a; // 'p' is high only when 'a' is high
    if (a) begin // 'a' is high
        if (prev_a) begin // 'a' has been high for two clock cycles
            q <= 1'b1; // Set 'q' high
        end else begin
            q <= q; // 'q' remains the same
        end
    end else begin // 'a' is low
        q <= 1'b0; // Reset 'q'
    end
end

endmodule