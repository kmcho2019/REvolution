module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg  [7:0] out
);

    reg [2:0] position;

    // State register: position of the active bit
    always @(posedge clk) begin
        if (reset) begin
            position <= 3'd0;
        end else begin
            position <= position + 3'd1; // Wraps around naturally at 3-bit width (0 to 7)
        end
    end

    // Combinational output decoding: one-hot encoding of position
    always @(*) begin
        case (position)
            3'd0: out = 8'b0000_0001;
            3'd1: out = 8'b0000_0010;
            3'd2: out = 8'b0000_0100;
            3'd3: out = 8'b0000_1000;
            3'd4: out = 8'b0001_0000;
            3'd5: out = 8'b0010_0000;
            3'd6: out = 8'b0100_0000;
            3'd7: out = 8'b1000_0000;
            default: out = 8'b0000_0001; // Default fallback, though position is 3 bits wide
        endcase
    end

endmodule