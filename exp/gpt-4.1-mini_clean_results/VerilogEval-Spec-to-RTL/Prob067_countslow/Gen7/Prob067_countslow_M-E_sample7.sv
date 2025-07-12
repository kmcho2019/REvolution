module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

// Internal one-hot state for counts 0 to 9 (10 states)
reg [9:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 10'b0000000001; // count=0 state
    end else if (slowena) begin
        // Rotate one-hot left by 1, wrap around
        // If current state is 10'b0000000001 (count=0), next is 10'b0000000010 (count=1), etc.
        // Find the position of the '1' bit and shift left; wrap from MSB to LSB
        case (state)
            10'b0000000001: state <= 10'b0000000010;
            10'b0000000010: state <= 10'b0000000100;
            10'b0000000100: state <= 10'b0000001000;
            10'b0000001000: state <= 10'b0000010000;
            10'b0000010000: state <= 10'b0000100000;
            10'b0000100000: state <= 10'b0001000000;
            10'b0001000000: state <= 10'b0010000000;
            10'b0010000000: state <= 10'b0100000000;
            10'b0100000000: state <= 10'b1000000000;
            10'b1000000000: state <= 10'b0000000001;
            default: state <= 10'b0000000001; // safety fallback
        endcase
    end
    // else hold state (no change)
end

// Convert one-hot state to binary count on q
always @(*) begin
    case (state)
        10'b0000000001: q = 4'd0;
        10'b0000000010: q = 4'd1;
        10'b0000000100: q = 4'd2;
        10'b0000001000: q = 4'd3;
        10'b0000010000: q = 4'd4;
        10'b0000100000: q = 4'd5;
        10'b0001000000: q = 4'd6;
        10'b0010000000: q = 4'd7;
        10'b0100000000: q = 4'd8;
        10'b1000000000: q = 4'd9;
        default:        q = 4'd0; // safety fallback
    endcase
end

endmodule