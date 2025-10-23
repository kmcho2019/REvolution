module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

// One-hot state: 10 bits for counts 1 to 10
reg [9:0] state;

// One-hot rotation and reset
always @(posedge clk) begin
    if (reset) begin
        // Reset to count 1 -> bit 0 set
        state <= 10'b0000000001;
    end else begin
        if (state == 10'b0100000000_0) begin
            // If at count 10 (bit 9), wrap to count 1 (bit 0)
            state <= 10'b0000000001;
        end else begin
            // Shift one-hot left by 1
            state <= state << 1;
        end
    end
end

// Decode one-hot state to binary count (1 to 10)
always @(*) begin
    case(state)
        10'b0000000001 : q = 4'd1;
        10'b0000000010 : q = 4'd2;
        10'b0000000100 : q = 4'd3;
        10'b0000001000 : q = 4'd4;
        10'b0000010000 : q = 4'd5;
        10'b0000100000 : q = 4'd6;
        10'b0001000000 : q = 4'd7;
        10'b0010000000 : q = 4'd8;
        10'b0100000000 : q = 4'd9;
        10'b1000000000 : q = 4'd10;
        default:       q = 4'd1; // default safe fallback
    endcase
end

endmodule