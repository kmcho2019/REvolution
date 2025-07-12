module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // 10-bit shift register: [stop][data7:0][start]
    reg [9:0] frame_reg;
    reg frame_valid;
    reg receiving;
    reg clk_en;

    // Shift register with clock gating
    always @(posedge clk) begin
        if (reset) begin
            frame_reg <= 10'b1111111111; // Idle state (all 1's)
            frame_valid <= 1'b0;
            receiving <= 1'b0;
        end else if (clk_en) begin
            frame_reg <= {in, frame_reg[9:1]}; // Shift right, MSB first
            
            // Detect when we've received a complete frame
            if (frame_reg[8:0] == 9'b1_xxxxxxx_0) begin // Stop bit and start bit present
                frame_valid <= frame_reg[9]; // Stop bit must be 1
            end
            
            // Track if we're in receiving mode
            receiving <= (frame_reg[0] == 1'b0) || (|frame_reg[8:1]);
        end
    end

    // Clock enable logic - only shift when needed
    always @(*) begin
        // Enable clock when:
        // 1. We see a start bit (falling edge)
        // 2. We're in the middle of receiving a frame
        // 3. We need to shift out a bad frame
        clk_en = (!in && !receiving) ||       // Start bit detection
                 (receiving && !frame_valid) || // Mid-frame
                 (frame_reg[0] == 0 && !in);   // Protocol violation recovery
    end

    // Done signal - registered output
    reg done_reg;
    always @(posedge clk) begin
        if (reset) begin
            done_reg <= 1'b0;
        end else begin
            done_reg <= frame_valid && (frame_reg[9:0] == 10'b1_xxxxxxx_0_1);
        end
    end

    assign done = done_reg;

endmodule