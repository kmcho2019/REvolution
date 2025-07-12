module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

    wire [16:0] next_count;

    // Zero-extend count to 17 bits and add +1 or -1 (represented by 17'd1 or 17'd65535) based on up_down
    // Using unsigned arithmetic to keep synthesis simple and efficient
    assign next_count = {1'b0, count} + (up_down ? 17'd1 : 17'd17'h1FFFF);

    always @(posedge clk) begin
        if (reset)
            count <= 16'd0;
        else
            count <= next_count[15:0];
    end

endmodule