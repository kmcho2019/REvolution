module up_down_counter (
    input  wire        clk,
    input  wire        reset,
    input  wire        enable,    // New enable input to gate counting
    input  wire        up_down,
    output reg [15:0]  count
);

    wire [15:0] delta;
    assign delta = up_down ? 16'd1 : 16'hFFFF; // +1 or -1 in 16-bit wrap-around arithmetic

    always @(posedge clk) begin
        if (reset)
            count <= 16'd0;
        else if (enable)
            count <= count + delta;
        // else hold current count (no toggling)
    end

endmodule