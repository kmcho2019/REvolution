module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);
    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
            tc <= (data == 10'd0);
        end else begin
            if (counter != 10'd0) begin
                counter <= counter - 1;
                tc <= (counter == 10'd1); // tc will be 1 next cycle when counter hits 0
            end else begin
                // counter at 0, stays 0
                tc <= 1'b1;
            end
        end
    end

endmodule