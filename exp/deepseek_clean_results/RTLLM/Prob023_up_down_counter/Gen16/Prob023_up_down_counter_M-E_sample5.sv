module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

parameter MAX_COUNT = 16'hFFFF;
parameter MIN_COUNT = 16'h0000;

always @(posedge clk) begin
    if (reset) begin
        count <= MIN_COUNT;
    end else begin
        if (up_down) begin
            // Increment with wrap-around
            count <= (count == MAX_COUNT) ? MIN_COUNT : count + 1'b1;
        end else begin
            // Decrement with wrap-around
            count <= (count == MIN_COUNT) ? MAX_COUNT : count - 1'b1;
        end
    end
end

endmodule