module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

    wire signed [16:0] delta;
    wire [16:0] next_count_ext;

    // Generate +1 when up_down=1, else -1 when up_down=0
    assign delta = up_down ? 17'sd1 : -17'sd1;

    // Extend count to 17 bits signed for addition to handle wrap-around correctly
    assign next_count_ext = {1'b0, count} + delta;

    always @(posedge clk) begin
        if (reset)
            count <= 16'd0;
        else
            count <= next_count_ext[15:0];  // lower 16 bits wrap-around naturally
    end

endmodule