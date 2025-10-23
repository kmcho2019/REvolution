module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    reg [9:0] frame_reg;  // Holds start + 8 data + stop bits
    reg capture_en;
    reg prev_in;
    wire start_edge = (prev_in == 1'b1) && (in == 1'b0);
    wire frame_valid = (frame_reg[9] == 1'b0) && (frame_reg[0] == 1'b1);

    // Input history for edge detection
    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 1'b1;
        end else begin
            prev_in <= in;
        end
    end

    // Capture enable logic
    always @(posedge clk) begin
        if (reset) begin
            capture_en <= 1'b0;
        end else begin
            if (start_edge) begin
                capture_en <= 1'b1;
            end else if (frame_valid) begin
                capture_en <= 1'b0;
            end
        end
    end

    // Shift register implementation
    always @(posedge clk) begin
        if (reset) begin
            frame_reg <= 10'b1111111111;  // Initialize to idle state
        end else if (capture_en) begin
            frame_reg <= {in, frame_reg[9:1]};  // Shift right, LSB first
        end else if (!capture_en) begin
            frame_reg <= 10'b1111111111;  // Reset to idle when not capturing
        end
    end

    // Done signal generation
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
        end else begin
            done <= frame_valid && capture_en;
        end
    end

endmodule