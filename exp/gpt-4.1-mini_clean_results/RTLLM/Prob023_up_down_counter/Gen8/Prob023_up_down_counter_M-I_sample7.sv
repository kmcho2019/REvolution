module up_down_counter (
    input  wire        clk,
    input  wire        reset,
    input  wire        up_down,
    input  wire        enable,       // New enable input to gate counting
    output reg [15:0]  count
);

    always @(posedge clk) begin
        if (reset)
            count <= 16'd0;
        else if (enable) begin
            if (up_down)
                count <= count + 16'd1;
            else
                count <= count - 16'd1;
        end
        // else retain previous count (no counting)
    end

endmodule