module ROM (
    input clk,              // Clock for output register
    input enable,           // Enable signal for power gating
    input [7:0] addr,       // 8-bit address input
    output reg [15:0] dout  // 16-bit registered output
);

    // Sparse memory implementation using case statement
    always @(*) begin
        if (enable) begin
            case (addr)
                8'h00: dout = 16'hA0A0;
                8'h01: dout = 16'hB1B1;
                8'h02: dout = 16'hC2C2;
                8'h03: dout = 16'hD3D3;
                default: dout = 16'h0000; // All other addresses return 0
            endcase
        end else begin
            dout = 16'h0000; // Output 0 when disabled
        end
    end

    // Optional: Register the output for better timing
    // Uncomment if pipelining is needed
    /*
    reg [15:0] dout_reg;
    always @(posedge clk) begin
        dout_reg <= dout;
    end
    assign dout = dout_reg;
    */

endmodule