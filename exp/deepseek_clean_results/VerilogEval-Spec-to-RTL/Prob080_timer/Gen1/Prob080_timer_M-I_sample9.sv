module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
            tc <= (data == 0);
        end else if (counter != 0) begin
            counter <= counter - 1;
            tc <= (counter == 1);  // Will be zero next cycle
        end
    end

endmodule