module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire counter_enable = ~tc;  // Only decrement when not at zero

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
        end else if (counter_enable) begin
            counter <= counter - 1'b1;
        end
    end

    assign tc = (counter == 10'b0);

endmodule