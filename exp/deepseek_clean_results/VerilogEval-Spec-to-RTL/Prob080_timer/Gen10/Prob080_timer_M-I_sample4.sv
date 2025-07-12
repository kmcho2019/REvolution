module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;
    wire counter_zero = (counter == 10'b0);

    // Clock gating control
    wire count_enable = ~counter_zero || load;

    // Next counter logic
    assign next_counter = load ? data : 
                        counter_zero ? 10'b0 : counter - 1;

    always @(posedge clk) begin
        if (count_enable) begin
            counter <= next_counter;
        end
        tc <= counter_zero;
    end

endmodule