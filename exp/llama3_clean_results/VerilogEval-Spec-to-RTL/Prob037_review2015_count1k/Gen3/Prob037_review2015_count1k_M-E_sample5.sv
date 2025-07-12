module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

// Define parameters for the counter
parameter MAX_HUNDREDS = 10'd9;
parameter MAX_TENS_ONES = 10'd99;

// Gray code counter for hundreds place
reg [3:0] hundreds_gray;
reg [3:0] hundreds_bin;

// Binary counter for tens and ones places
reg [6:0] tens_ones;

always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to 0
        hundreds_gray <= 4'd0;
        tens_ones <= 7'd0;
    end else begin
        // Increment the tens and ones counter
        if (tens_ones == MAX_TENS_ONES) begin
            // Reset tens and ones counter and increment hundreds counter
            tens_ones <= 7'd0;
            if (hundreds_gray == {3'b110, 1'b0}) begin
                // Wrap around to 0 when hundreds counter reaches 9
                hundreds_gray <= 4'd0;
            end else begin
                // Increment hundreds counter using Gray code
                case (hundreds_gray)
                    4'd0: hundreds_gray <= 4'd1;
                    4'd1: hundreds_gray <= 4'd3;
                    4'd3: hundreds_gray <= 4'd2;
                    4'd2: hundreds_gray <= 4'd6;
                    4'd6: hundreds_gray <= 4'd7;
                    4'd7: hundreds_gray <= 4'd5;
                    4'd5: hundreds_gray <= 4'd4;
                    4'd4: hundreds_gray <= 4'd12;
                    4'd12: hundreds_gray <= 4'd9;
                    4'd9: hundreds_gray <= 4'd8;
                    4'd8: hundreds_gray <= 4'd10;
                    4'd10: hundreds_gray <= 4'd11;
                    4'd11: hundreds_gray <= 4'd13;
                    4'd13: hundreds_gray <= 4'd14;
                    4'd14: hundreds_gray <= 4'd1;
                    default: hundreds_gray <= 4'd0;
                endcase
            end
        end else begin
            // Increment tens and ones counter
            tens_ones <= tens_ones + 1;
        end
    end
end

// Convert Gray code to binary for hundreds place
always @(hundreds_gray) begin
    case (hundreds_gray)
        4'd0: hundreds_bin <= 4'd0;
        4'd1: hundreds_bin <= 4'd1;
        4'd3: hundreds_bin <= 4'd2;
        4'd2: hundreds_bin <= 4'd3;
        4'd6: hundreds_bin <= 4'd4;
        4'd7: hundreds_bin <= 4'd5;
        4'd5: hundreds_bin <= 4'd6;
        4'd4: hundreds_bin <= 4'd7;
        4'd12: hundreds_bin <= 4'd8;
        4'd9: hundreds_bin <= 4'd9;
        4'd8: hundreds_bin <= 4'd10;
        4'd10: hundreds_bin <= 4'd11;
        4'd11: hundreds_bin <= 4'd12;
        4'd13: hundreds_bin <= 4'd13;
        4'd14: hundreds_bin <= 4'd14;
        default: hundreds_bin <= 4'd0;
    endcase
end

// Assign output
assign q = {hundreds_bin, tens_ones};

endmodule