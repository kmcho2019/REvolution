module TopModule (
    input  wire clk,
    input  wire reset,           // Active high synchronous reset
    input  wire pattern_detected,// Signal indicating pattern detection
    output reg  shift_ena
);

    reg [2:0] shift_count;  // 3-bit counter, counts down from 4 to 0

    always @(posedge clk) begin
        if (reset) begin
            // On synchronous reset, load counter to 4 and assert shift_ena
            shift_count <= 3'd4;
            shift_ena <= 1'b1;
        end else if (pattern_detected) begin
            // On pattern detection event, also load counter to 4 and assert shift_ena
            shift_count <= 3'd4;
            shift_ena <= 1'b1;
        end else if (shift_count != 3'd0) begin
            // Count down each clock cycle while shift_ena asserted
            shift_count <= shift_count - 3'd1;
            // Assert shift_ena as long as counter > 0
            shift_ena <= 1'b1;
        end else begin
            // Counter is zero, deassert shift_ena indefinitely until next trigger
            shift_ena <= 1'b0;
        end
    end

endmodule