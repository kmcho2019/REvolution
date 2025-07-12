module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

    reg [9:0] counter;
    wire counter_zero = (counter == 10'b0);
    wire clk_en = ~counter_zero || load;
    wire [9:0] next_counter = load ? data : counter - 1;
    
    always @(posedge clk) begin
        if (clk_en) begin
            counter <= next_counter;
            tc <= counter_zero;
        end
    end

endmodule