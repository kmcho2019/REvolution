module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output [15:0] count
);

reg [15:0] counter; // internal reg to hold the counter value

always @ (posedge clk) begin
    if (reset) begin
        // if reset is high, reset the counter to zero
        counter <= 16'd0;
    end else begin
        // if up_down is high, increment the counter
        if (up_down) begin
            counter <= counter + 1;
        end 
        // if up_down is low, decrement the counter
        else begin
            counter <= counter - 1;
        end
    end
end

assign count = counter; // assign the internal counter value to the output

endmodule