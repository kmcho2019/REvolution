module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;
    wire counter_is_zero = (counter == 10'b0);
    wire counter_enable = load | ~counter_is_zero;
    wire [9:0] decremented = counter - 1'b1;
    
    // Optimized next counter value logic
    assign next_counter = load ? data : 
                        decremented;

    // Clock-gated D flip-flop implementation
    always @(posedge clk) begin
        if (counter_enable) begin
            counter <= next_counter;
        end
    end

    // Terminal count output
    assign tc = counter_is_zero;

endmodule