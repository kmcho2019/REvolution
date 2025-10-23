module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] pattern;
reg direction;  // 0 = left (decrement), 1 = right (increment)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pattern <= 5'b00001;
        direction <= 1'b1;  // Start by moving right
    end
    else begin
        // Shift based on direction
        if (direction) begin
            pattern <= {pattern[3:0], 1'b0};  // Shift right
        end
        else begin
            pattern <= {1'b0, pattern[4:1]};  // Shift left
        end
        
        // Check for direction change
        if (pattern[4] && direction) begin
            direction <= 1'b0;  // Change to left shift
            pattern <= {1'b0, pattern[4:1]};  // Immediate correction
        end
        else if (pattern[0] && !direction) begin
            direction <= 1'b1;  // Change to right shift
            pattern <= {pattern[3:0], 1'b0};  // Immediate correction
        end
    end
end

// Convert one-hot pattern to binary value
always @(*) begin
    case (pattern)
        5'b00001: wave = 5'd0;
        5'b00010: wave = 5'd1;
        5'b00100: wave = 5'd2;
        5'b01000: wave = 5'd3;
        5'b10000: wave = 5'd4;
        default: wave = 5'd0;  // Should never happen
    endcase
    
    // Scale up to full range (0-31) by multiplying position by 8
    // This maintains the triangle wave shape while using full 5-bit range
    wave = wave * 5'd8;
end

endmodule