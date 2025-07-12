module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

    reg [9:0] counter;
    wire counter_zero = (counter == 10'b0);
    wire [9:0] decremented = counter - 1'b1;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
            tc <= 1'b0;
        end
        else if (!counter_zero) begin
            counter <= decremented;
            tc <= (decremented == 10'b0);
        end
        else begin
            tc <= 1'b1;
        end
    end

endmodule