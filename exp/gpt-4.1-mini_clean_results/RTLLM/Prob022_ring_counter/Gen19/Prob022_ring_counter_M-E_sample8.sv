module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    reg [2:0] position; // 3 bits to represent positions 0-7

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            position <= 3'd0;
            out <= 8'b00000001;
        end else begin
            // Increment position modulo 8
            if (position == 3'd7)
                position <= 3'd0;
            else
                position <= position + 3'd1;

            // Update output based on position
            out <= 8'b00000001 << position;
        end
    end

endmodule