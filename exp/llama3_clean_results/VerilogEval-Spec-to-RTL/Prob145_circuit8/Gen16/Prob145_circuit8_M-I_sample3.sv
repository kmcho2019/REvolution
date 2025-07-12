module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a; // To store the previous value of 'a'

always @(posedge clock) begin
    if (a && !prev_a) begin // 'a' has just become high
        p <= 1'b1; // Set 'p' high
        q <= 1'b0; // 'q' remains low
    end else if (a && prev_a) begin // 'a' has been high for two clock cycles
        p <= 1'b1; // 'p' remains high
        q <= 1'b1; // Set 'q' high
    end else begin // 'a' is low
        p <= 1'b0; // Reset 'p' and 'q'
        q <= 1'b0;
    end
    prev_a <= a; // Update the previous value of 'a'
end

endmodule