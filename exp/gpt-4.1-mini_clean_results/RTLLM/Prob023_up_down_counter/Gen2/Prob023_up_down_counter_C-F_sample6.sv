module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

    wire [15:0] next_count;
    wire enable;

    assign next_count = up_down ? (count + 16'd1) : (count - 16'd1);
    assign enable = ~reset;

    always @(posedge clk) begin
        if (reset)
            count <= 16'd0;
        else if (enable)
            count <= next_count;
    end

endmodule