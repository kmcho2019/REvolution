module up_down_counter (
    input  wire        clk,
    input  wire        reset,
    input  wire        up_down,
    output reg [15:0]  count
);

    wire [15:0] delta;
    wire [15:0] next_count;

    // delta is +1 if up_down=1, else -1 (two's complement)
    assign delta = up_down ? 16'd1 : 16'hFFFF; // 16'hFFFF == -1 in 2's complement

    // next_count is current count plus delta
    assign next_count = count + delta;

    always @(posedge clk) begin
        if (reset) begin
            count <= 16'd0;
        end else begin
            count <= next_count;
        end
    end

endmodule