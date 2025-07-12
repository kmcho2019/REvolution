module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

    reg [9:0] counter;
    wire [9:0] next_count = counter - 1'b1;
    wire counter_enable = ~load & (counter != 0);

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
            tc <= 1'b0;
        end else if (counter_enable) begin
            counter <= next_count;
            tc <= (next_count == 0);
        end
    end

endmodule