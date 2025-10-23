module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

    reg [9:0] counter;
    wire counter_enable = ~tc || load;
    wire [9:0] next_counter = load ? data : 
                            (counter == 0) ? 10'b0 : 
                            counter - 1;

    always @(posedge clk) begin
        if (counter_enable) begin
            counter <= next_counter;
        end
        tc <= (counter == 0);
    end

endmodule