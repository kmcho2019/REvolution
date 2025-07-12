module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    reg [2:0] pos;  // position of the '1' bit (0 to 7)

    // State update: increment position on each clock, reset to 0
    always @(posedge clk) begin
        if (reset)
            pos <= 3'd0;
        else
            pos <= pos + 3'd1;
    end

    // Combinational logic to decode position to one-hot output
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
            default: out = 8'b00000001;  // default to LSB set
        endcase
    end

endmodule