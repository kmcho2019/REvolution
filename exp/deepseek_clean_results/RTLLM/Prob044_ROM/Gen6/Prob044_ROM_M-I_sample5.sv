module ROM (
    input [7:0] addr,
    input en,          // Added enable signal for power gating
    output reg [15:0] dout  // Changed to reg for case statement
);

    // Memory implemented as case statement for area optimization
    always @(*) begin
        if (en) begin
            case (addr)
                8'h00: dout = 16'hA0A0;
                8'h01: dout = 16'hB1B1;
                8'h02: dout = 16'hC2C2;
                8'h03: dout = 16'hD3D3;
                default: dout = 16'h0000; // All other addresses return 0
            endcase
        end
        else begin
            dout = 16'h0000; // Output 0 when disabled
        end
    end

    /* Alternative implementation comment:
    // Original memory array implementation (kept for reference)
    reg [15:0] mem [0:255];
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
    end
    assign dout = en ? mem[addr] : 16'h0000;
    */

endmodule