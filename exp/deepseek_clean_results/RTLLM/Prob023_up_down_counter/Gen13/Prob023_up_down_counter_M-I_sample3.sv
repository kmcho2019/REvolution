module up_down_counter #(
    parameter WIDTH = 16
) (
    input clk,
    input reset,
    input up_down,
    output reg [WIDTH-1:0] count
);

// Clock gating signal
wire count_enable = ~reset & (up_down | (|count)); // Enable when not reset and (counting up or count not zero)

// Carry-select like structure for better timing
always @(posedge clk) begin
    if (reset) begin
        count <= {WIDTH{1'b0}};
    end else if (count_enable) begin
        if (up_down) begin
            // Increment operation
            count <= count + 1'b1;
        end else begin
            // True decrement operation
            count <= count - 1'b1;
        end
    end
end

endmodule