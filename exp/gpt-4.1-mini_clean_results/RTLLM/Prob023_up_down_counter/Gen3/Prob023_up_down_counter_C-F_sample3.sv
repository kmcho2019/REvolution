module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

    wire signed [16:0] next_count;

    // Compute next count based on up_down in a single arithmetic expression
    assign next_count = $signed({1'b0, count}) + (up_down ? 17'sd1 : -17'sd1);

    always @(posedge clk) begin
        if (reset)
            count <= 16'd0;
        else
            count <= next_count[15:0];
    end

endmodule