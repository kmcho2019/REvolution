module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg  [7:0] out
);

    reg [2:0] pos;

    // Counter updates position on clock edge
    always @(posedge clk or posedge reset) begin
        if (reset)
            pos <= 3'd0;      // Initialize position to 0 (LSB)
        else
            pos <= pos + 3'd1; // Increment modulo 8 (3-bit wrap-around)
    end

    // Output one-hot encoding of pos
    always @(*) begin
        out = 8'b0;
        case (pos)
            3'd0: out = 8'b00000001;
            3'd1: out = 8'b00000010;
            3'd2: out = 8'b00000100;
            3'd3: out = 8'b00001000;
            3'd4: out = 8'b00010000;
            3'd5: out = 8'b00100000;
            3'd6: out = 8'b01000000;
            3'd7: out = 8'b10000000;
            default: out = 8'b00000001; // default safety fallback
        endcase
    end

endmodule