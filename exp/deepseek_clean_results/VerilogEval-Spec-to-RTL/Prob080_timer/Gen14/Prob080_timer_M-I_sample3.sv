module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

    reg [9:0] counter;
    wire counter_zero = ~|counter;
    wire clk_enable = load | ~counter_zero;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
            tc <= 1'b0;  // Clear tc immediately on load
        end
        else if (clk_enable) begin
            if (~counter_zero) begin
                counter <= counter - 1;
                tc <= (counter == 10'd1);  // Set tc one cycle early
            end
        end
    end

endmodule