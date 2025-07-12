module TopModule(
    input clk,
    input d,
    output reg q
);
    // Initialize output q
    initial begin
        q = 1'b0;
    end

    // The always block is used for sequential logic and is triggered on the positive edge of the clock.
    always @(posedge clk) begin
        // The non-blocking assignment operator (<=) is used for assigning values to the output q.
        // This operator is preferred in sequential logic descriptions for its ability to handle race conditions and to provide a clear, predictable simulation behavior.
        q <= d;
    end
endmodule