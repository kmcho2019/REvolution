module up_down_counter(
    input clk,        // Clock signal
    input reset,      // Reset signal
    input up_down,    // Control signal for up/down counting
    output reg [15:0] count  // 16-bit counter output
);

always @ (posedge clk) begin
    if (reset) begin
        // Reset the counter to zero when reset is active
        count <= 16'd0;
    end else begin
        // Count up if up_down is high
        if (up_down) begin
            count <= count + 1;
        end 
        // Count down if up_down is low
        else begin
            count <= count - 1;
        end
    end
end

endmodule