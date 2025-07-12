module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] a_count; // Counter to track consecutive 'a' highs

always @(posedge clock) begin
    p <= a; // 'p' is high when 'a' is high

    if (a) begin // 'a' is high
        a_count <= a_count + 1; // Increment counter
        if (a_count >= 2) begin // 'a' has been high for at least two clock cycles
            q <= 1'b1; // Set 'q' high
        end else begin
            q <= 1'b0; // 'q' remains low
        end
    end else begin // 'a' is low
        a_count <= 0; // Reset counter
        q <= 1'b0; // Reset 'q'
    end
end

endmodule