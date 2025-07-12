module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire counter_is_minus1 = &counter;  // Check if all bits are 1 (equals -1)

    always @(posedge clk) begin
        if (load)
            counter <= data - 1;  // Pre-decrement when loading
        else if (!counter_is_minus1)
            counter <= counter - 1;  // Normal countdown
        // Else stay at -1 (no action needed)
    end

    assign tc = counter_is_minus1;

endmodule