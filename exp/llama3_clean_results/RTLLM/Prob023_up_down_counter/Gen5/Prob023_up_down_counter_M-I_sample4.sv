module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else if (up_down) begin
        // Increment logic using bitwise operations for efficiency
        count <= count + 1;
    end else begin
        // Decrement logic, considering the boundary condition (0)
        count <= (count == 16'd0) ? 16'd0 : count - 1;
    end
end

endmodule