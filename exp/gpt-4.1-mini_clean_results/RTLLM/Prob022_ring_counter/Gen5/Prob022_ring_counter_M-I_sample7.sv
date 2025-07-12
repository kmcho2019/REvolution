module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    reg [2:0] active_bit_index;

    always @(posedge clk) begin
        if (reset) begin
            active_bit_index <= 3'd0;  // Initialize index to LSB
        end else begin
            active_bit_index <= active_bit_index + 3'd1;  // Increment index modulo 8
        end
    end

    always @(*) begin
        // Decode active_bit_index to output one-hot signal on out
        out = 8'b0000_0000;
        case (active_bit_index)
            3'd0: out[0] = 1'b1;
            3'd1: out[1] = 1'b1;
            3'd2: out[2] = 1'b1;
            3'd3: out[3] = 1'b1;
            3'd4: out[4] = 1'b1;
            3'd5: out[5] = 1'b1;
            3'd6: out[6] = 1'b1;
            3'd7: out[7] = 1'b1;
            default: out = 8'b00000001; // default fallback, should not occur
        endcase
    end

endmodule