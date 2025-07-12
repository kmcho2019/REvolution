module up_down_counter(
    input clk, // clock signal
    input reset, // reset signal
    input up_down, // control signal to determine counting direction
    output reg [15:0] count // 16-bit output representing the current counter value
);

always @(posedge clk) begin
    if (reset) begin
        // reset the counter to zero
        count <= 16'd0;
    end else if (up_down) begin
        // increment the counter
        count <= count + 1;
    end else begin
        // decrement the counter
        count <= count - 1;
    end
end

endmodule