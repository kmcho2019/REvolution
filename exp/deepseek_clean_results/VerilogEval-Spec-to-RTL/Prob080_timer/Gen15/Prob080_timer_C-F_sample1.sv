module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;
    wire counter_zero = ~|counter;  // NOR reduction for zero detection

    // Combinational logic for next counter value
    assign next_counter = load ? data : 
                        (counter_zero ? 10'b0 : counter - 10'b1);

    // Sequential logic (single D flip-flop)
    always @(posedge clk) begin
        counter <= next_counter;
    end

    // Terminal count output
    assign tc = counter_zero;

endmodule