module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire pattern_detected, // Input indicating the bit pattern detection
    output reg  shift_ena
);

    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd4;       // Start counting 4 cycles on reset
            shift_ena <= 1'b1;
        end else if (pattern_detected) begin
            count <= 3'd4;       // Start counting 4 cycles on pattern detection
            shift_ena <= 1'b1;
        end else if (count != 0) begin
            count <= count - 3'd1;
            shift_ena <= 1'b1;   // Keep enabled while counting down
        end else begin
            shift_ena <= 1'b0;   // Disable after 4 cycles complete
        end
    end

endmodule