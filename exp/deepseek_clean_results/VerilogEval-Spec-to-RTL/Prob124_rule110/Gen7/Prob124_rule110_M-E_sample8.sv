module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Segment processing state machine
    reg [5:0] segment_ptr;  // 0-63
    reg [9:0] window;       // 8 bits + 2 boundary bits
    reg processing;
    
    // Function implementing Rule 110 logic for 8 bits
    function [7:0] rule110_byte;
        input [9:0] win;  // [9:8] = left boundary, [7:0] = current byte, [0] = right boundary
        reg [2:0] pattern;
        integer i;
        begin
            for (i = 0; i < 8; i = i + 1) begin
                pattern = {i == 7 ? win[9] : win[i+1], win[i], i == 0 ? win[0] : win[i-1]};
                case (pattern)
                    3'b111: rule110_byte[i] = 0;
                    3'b110: rule110_byte[i] = 1;
                    3'b101: rule110_byte[i] = 1;
                    3'b100: rule110_byte[i] = 0;
                    3'b011: rule110_byte[i] = 1;
                    3'b010: rule110_byte[i] = 1;
                    3'b001: rule110_byte[i] = 1;
                    3'b000: rule110_byte[i] = 0;
                endcase
            end
        end
    endfunction

    wire [7:0] next_byte = rule110_byte(window);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            segment_ptr <= 0;
            processing <= 1'b1;
        end else if (processing) begin
            // Update current segment
            q[segment_ptr*8 +: 8] <= next_byte;
            
            // Prepare window for next segment
            window[9:8] <= q[segment_ptr*8 + 7];  // Left boundary
            window[7:0] <= q[((segment_ptr + 1) % 64)*8 +: 8];  // Next segment
            window[0] <= segment_ptr == 63 ? 1'b0 : q[((segment_ptr + 2) % 64)*8];  // Right boundary
            
            // Advance pointer
            segment_ptr <= segment_ptr + 1;
            processing <= (segment_ptr != 63);
        end else begin
            // Initialize processing
            window[9:8] <= 1'b0;  // Left boundary
            window[7:0] <= q[7:0];
            window[0] <= q[8];    // Right boundary
            segment_ptr <= 0;
            processing <= 1'b1;
        end
    end

endmodule