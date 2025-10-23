module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a; // To store the previous value of 'a'

always @(posedge clock) begin
    prev_a <= a; // Update the previous value of 'a'
    if (a) begin // 'a' is high
        p <= 1'b1; // Set 'p' high
        if (prev_a) begin // 'a' has been high for two clock cycles
            q <= 1'b1; // Set 'q' high
        end else begin
            q <= 1'b0; // 'q' remains low
        end
    end else begin // 'a' is low
        p <= 1'b0; // Reset 'p'
        q <= 1'b0; // Reset 'q'
    end
end

endmodule