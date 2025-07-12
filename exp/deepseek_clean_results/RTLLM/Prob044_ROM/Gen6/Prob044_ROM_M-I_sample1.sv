module ROM (
    input [7:0] addr,
    input en,          // Added enable signal for power gating
    output reg [15:0] dout  // Changed to reg for case statement
);

    // Implement ROM using case statement instead of memory array
    always @(*) begin
        if (en) begin
            case (addr)
                8'h00: dout = 16'hA0A0;
                8'h01: dout = 16'hB1B1;
                8'h02: dout = 16'hC2C2;
                8'h03: dout = 16'hD3D3;
                default: dout = 16'h0000;  // Initialize unused to 0 for power
            endcase
        end
        else begin
            dout = 16'h0000;  // Output 0 when disabled
        end
    end

endmodule