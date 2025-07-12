module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  shift_ena
);

    reg [2:0] count; // 3-bit counter sufficient for counting down from 4

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd4;      // Initialize counter to 4 on reset
            shift_ena <= 1'b1;  // Assert shift_ena immediately on reset
        end else if (count != 0) begin
            count <= count - 3'd1; 
            shift_ena <= 1'b1;  // Keep shift_ena asserted while count > 0
        end else begin
            shift_ena <= 1'b0;  // Deassert shift_ena after 4 cycles
        end
    end

endmodule