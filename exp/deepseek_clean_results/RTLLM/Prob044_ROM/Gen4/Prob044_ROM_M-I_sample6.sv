module ROM (
    input clk,            // Clock for output register
    input enable,         // Enable signal for power control
    input [7:0] addr,     // 8-bit address input
    output reg [15:0] dout // 16-bit registered output
);

    // Combinational logic for ROM read
    wire [15:0] rom_data;

    // Sparse ROM implementation using case statement
    always @(*) begin
        if (enable) begin
            case (addr)
                8'h00: rom_data = 16'hA0A0;
                8'h01: rom_data = 16'hB1B1;
                8'h02: rom_data = 16'hC2C2;
                8'h03: rom_data = 16'hD3D3;
                default: rom_data = 16'h0000;
            endcase
        end else begin
            rom_data = 16'h0000; // Output zeros when disabled
        end
    end

    // Register the output for better timing
    always @(posedge clk) begin
        dout <= rom_data;
    end

endmodule