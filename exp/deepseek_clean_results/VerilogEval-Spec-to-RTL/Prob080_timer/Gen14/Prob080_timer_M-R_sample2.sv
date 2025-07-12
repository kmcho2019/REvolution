module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    wire [9:0] counter;
    wire [9:0] next_counter;
    wire counter_zero;
    wire counter_enable;

    // Combinational logic
    assign counter_zero = (counter == 10'b0);
    assign next_counter = load ? data : 
                        (counter_zero ? 10'b0 : counter - 10'b1);
    assign counter_enable = load | ~counter_zero;

    // Clock-gated register implementation
    reg [9:0] counter_ff;
    assign counter = counter_ff;
    always @(posedge clk) begin
        if (counter_enable) begin
            counter_ff <= next_counter;
        end
    end

    // Terminal count output
    assign tc = counter_zero;

endmodule