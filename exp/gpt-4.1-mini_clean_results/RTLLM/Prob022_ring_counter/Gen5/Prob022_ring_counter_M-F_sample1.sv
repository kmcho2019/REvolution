module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    // Index of the active bit (0 to 7)
    reg [2:0] active_pos;

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            active_pos <= 3'd0;  // Initialize active bit position to 0
        end else begin
            if (active_pos == 3'd7)
                active_pos <= 3'd0;
            else
                active_pos <= active_pos + 3'd1;
        end

        // Set output bits individually based on active_pos
        for (i = 0; i < 8; i = i + 1) begin
            if (i == active_pos)
                out[i] <= 1'b1;
            else
                out[i] <= 1'b0;
        end
    end

endmodule