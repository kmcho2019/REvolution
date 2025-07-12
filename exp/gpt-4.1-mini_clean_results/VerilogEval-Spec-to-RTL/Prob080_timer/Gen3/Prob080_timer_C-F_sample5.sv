module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            // Load counter with input data when load is high
            counter <= data;
        end else if (|counter) begin
            // Decrement counter only if it is nonzero and load is low
            counter <= counter - 10'd1;
        end
        // Otherwise hold counter at zero (no toggling)
    end

    // Terminal count asserted when counter reaches zero
    assign tc = ~|counter;

endmodule