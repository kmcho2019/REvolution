module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire counter_enable = (counter != 0) && !load;
    wire [9:0] next_counter;

    // Optimized next counter logic
    assign next_counter = load ? data : 
                         counter - {9'b0, counter_enable};  // Conditional decrement

    // Sequential logic with enable
    always @(posedge clk) begin
        if (load || counter_enable)
            counter <= next_counter;
    end

    // Optimized terminal count (NOR gate implementation)
    assign tc = ~|counter;

endmodule