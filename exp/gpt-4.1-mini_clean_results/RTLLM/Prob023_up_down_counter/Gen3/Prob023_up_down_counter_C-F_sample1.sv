module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

    wire enable;
    wire [15:0] next_count;

    assign enable = ~reset;

    // Use addition of 1 or two's complement (-1) for increment/decrement
    assign next_count = up_down ? (count + 16'd1) : (count + 16'hFFFF);

    always @(posedge clk) begin
        if (reset)
            count <= 16'd0;
        else if (enable)
            count <= next_count;
    end

endmodule