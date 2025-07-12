module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output wire [7:0] out
);

    reg [2:0] position;  // tracks which bit is set (0 to 7)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            position <= 3'd0;
        end else begin
            if (position == 3'd7)
                position <= 3'd0;
            else
                position <= position + 3'd1;
        end
    end

    // Combinational one-hot output derived from position
    assign out = 8'b1 << position;

endmodule