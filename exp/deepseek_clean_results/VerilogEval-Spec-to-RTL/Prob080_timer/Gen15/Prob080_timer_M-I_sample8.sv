module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire counter_zero = ~|counter;
    wire clock_enable = ~counter_zero || load;
    wire [9:0] decremented = counter - 1'b1;
    wire [9:0] next_counter = load ? data : decremented;
    
    assign tc = counter_zero;
    
    always @(posedge clk) begin
        if (clock_enable) begin
            counter <= next_counter;
        end
    end

endmodule