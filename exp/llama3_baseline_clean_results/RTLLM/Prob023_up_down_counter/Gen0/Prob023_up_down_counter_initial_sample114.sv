module up_down_counter(
    input clk, 
    input reset, 
    input up_down, 
    output reg [15:0] count
);

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0; // reset counter to zero when reset signal is active
    end else begin
        if (up_down) begin
            count <= count + 1; // increment counter when up_down is high
        end else begin
            count <= count - 1; // decrement counter when up_down is low
        end
    end
end

endmodule