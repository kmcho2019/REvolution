module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

    reg [9:0] counter;
    wire counter_enable = load || (~tc);  // Enable counter when loading or not timed out

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
            tc <= 1'b0;  // Reset tc when loading new value
        end
        else if (counter_enable) begin
            if (counter == 10'd1) begin  // Detect terminal count one cycle early
                counter <= 10'b0;
                tc <= 1'b1;
            end
            else if (~tc) begin
                counter <= counter - 1;
            end
        end
    end

endmodule