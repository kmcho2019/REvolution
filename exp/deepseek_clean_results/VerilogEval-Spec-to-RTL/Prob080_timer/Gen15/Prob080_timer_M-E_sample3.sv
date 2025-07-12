module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_value;
    wire counter_zero;

    // Parallel decrement logic (simple bit manipulation)
    assign next_value = counter - 1'b1;

    // Zero detection using NOR tree
    assign counter_zero = ~(|counter);

    // Sequential logic with parallel load
    always @(posedge clk) begin
        if (load)
            counter <= data;
        else if (!counter_zero)
            counter <= next_value;
        // else remains 0 (implied)
    end

    // Terminal count output
    assign tc = counter_zero;

endmodule