module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

    reg [9:0] counter;
    wire counter_enable = (counter != 0) && !load;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
            tc <= 1'b0;
        end
        else if (counter_enable) begin
            counter <= counter - 1;
            tc <= (counter == 10'd1);
        end
        else if (counter == 0) begin
            tc <= 1'b1;
        end
    end

endmodule