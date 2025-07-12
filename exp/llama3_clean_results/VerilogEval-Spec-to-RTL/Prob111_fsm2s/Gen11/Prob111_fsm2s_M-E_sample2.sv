module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg [0:0] counter; // Single-bit counter for OFF (0) and ON (1) states

// Output logic
assign out = counter[0]; // Directly assign counter value to output

// Counter with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        counter <= 1'b0; // Reset to OFF state
    end else begin
        if (j && !counter[0]) begin
            counter <= counter + 1'b1; // Increment counter when j is high and in OFF state
        end else if (k && counter[0]) begin
            counter <= counter - 1'b1; // Decrement counter when k is high and in ON state
        end
    end
end

endmodule