module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    // Internal one-hot state register: 10 bits for states 0 to 9
    reg [9:0] ring_state;

    // Decode ring_state (one-hot) to binary q
    always @(*) begin
        case (ring_state)
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
            default: q = 4'd0; // Safe default if invalid state
        endcase
    end

    always @(posedge clk) begin
        if (reset)
            ring_state <= 10'b0000000001;  // Start at state 0 (one-hot bit 0)
        else begin
            // Rotate the one-hot bit left by 1, wrap around at the 10th bit
            // Extract leftmost bit to wrap it around
            if (ring_state[9])
                ring_state <= 10'b0000000001;
            else
                ring_state <= ring_state << 1;
        end
    end

endmodule