module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    reg [2:0] index;  // 3-bit index to track position 0-7

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            index <= 3'b000;
            out <= 8'b00000001;
        end else begin
            if (index == 3'd7)
                index <= 3'b000;
            else
                index <= index + 3'b001;
            out <= 8'b00000001 << index;
        end
    end

endmodule