module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

    reg [9:0] counter;
    wire counter_zero = (counter == 10'b0);

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
            tc <= 1'b0;
        end else if (!counter_zero) begin
            counter <= counter - 1'b1;
            tc <= (counter == 10'b1); // Next cycle will be zero
        end else begin
            tc <= 1'b1;
        end
    end

endmodule