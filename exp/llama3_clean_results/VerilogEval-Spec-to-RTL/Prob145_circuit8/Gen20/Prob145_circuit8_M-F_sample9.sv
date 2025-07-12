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
    end else begin
        p <= 1'b0; // Reset 'p' when 'a' is low
    end

    if (a && a_prev) begin // 'a' has been high for two consecutive clock cycles
        q <= 1'b1; // Set 'q' high
    end else if (!a && a_prev) begin // 'a' was high in the previous clock cycle and is low in the current clock cycle
        q <= 1'b1; // Set 'q' high
    end else begin
        q <= 1'b0; // Reset 'q'
    end
    
    a_prev <= a; // Update the previous value of 'a' at the end of the clock cycle
end

endmodule