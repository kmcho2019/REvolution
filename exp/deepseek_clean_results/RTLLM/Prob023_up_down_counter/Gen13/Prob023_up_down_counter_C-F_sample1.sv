module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;
    end else begin
        case (up_down)
            1'b1: count <= count + 1'b1;  // Efficient increment
            1'b0: count <= count - 1'b1;  // Direct decrement (better than +FFFF)
        endcase
    end
end

endmodule