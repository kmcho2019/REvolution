module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    reg [2:0] position;  // 3-bit index for position of the '1' bit (0-7)

    // Sequential logic: update position on clock or reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            position <= 3'd0; // initialize position to LSB
        end else begin
            position <= (position == 3'd7) ? 3'd0 : position + 1;
        end
    end

    // Combinational logic: generate one-hot output based on position
    always @(*) begin
        out = 8'b0;
        case (position)
            3'd0: out = 8'b00000001;
            3'd1: out = 8'b00000010;
            3'd2: out = 8'b00000100;
            3'd3: out = 8'b00001000;
            3'd4: out = 8'b00010000;
            3'd5: out = 8'b00100000;
            3'd6: out = 8'b01000000;
            3'd7: out = 8'b10000000;
            default: out = 8'b00000001; // default safe state
        endcase
    end

endmodule