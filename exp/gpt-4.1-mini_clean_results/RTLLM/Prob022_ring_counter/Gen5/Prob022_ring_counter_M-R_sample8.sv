module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    reg [2:0] current_bit;  // 3-bit counter for position 0..7

    // Sequential block to update current_bit index
    always @(posedge clk) begin
        if (reset) begin
            current_bit <= 3'd0;   // Reset to bit 0 (LSB)
        end else begin
            current_bit <= current_bit + 3'd1;  // Increment modulo 8 automatically by 3-bit width
        end
    end

    // Combinational assignment to generate one-hot output based on current_bit
    always @(*) begin
        out = 8'b00000000;
        case (current_bit)
            3'd0: out = 8'b00000001;
            3'd1: out = 8'b00000010;
            3'd2: out = 8'b00000100;
            3'd3: out = 8'b00001000;
            3'd4: out = 8'b00010000;
            3'd5: out = 8'b00100000;
            3'd6: out = 8'b01000000;
            3'd7: out = 8'b10000000;
            default: out = 8'b00000001; // Safety fallback
        endcase
    end

endmodule