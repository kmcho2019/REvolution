module ring_counter (
    input clk,
    input reset,
    output [7:0] out
);

    reg [2:0] position; // 3-bit position register for the single '1' bit

    // Sequential logic to update position on clk or reset
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

    // Combinational assignment of output based on position
    assign out = 8'b00000001 << position;

endmodule