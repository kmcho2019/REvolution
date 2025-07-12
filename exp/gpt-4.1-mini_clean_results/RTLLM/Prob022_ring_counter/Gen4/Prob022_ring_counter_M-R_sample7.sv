module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg  [7:0] out
);

reg [2:0] position; // position of the '1' bit (0 to 7)

always @(posedge clk) begin
    if (reset) begin
        position <= 3'b000;
    end else begin
        if (position == 3'd7)
            position <= 3'b000;
        else
            position <= position + 3'b001;
    end
end

always @(*) begin
    // Decode position into one-hot output
    case (position)
        3'd0: out = 8'b00000001;
        3'd1: out = 8'b00000010;
        3'd2: out = 8'b00000100;
        3'd3: out = 8'b00001000;
        3'd4: out = 8'b00010000;
        3'd5: out = 8'b00100000;
        3'd6: out = 8'b01000000;
        3'd7: out = 8'b10000000;
        default: out = 8'b00000001;
    endcase
end

endmodule