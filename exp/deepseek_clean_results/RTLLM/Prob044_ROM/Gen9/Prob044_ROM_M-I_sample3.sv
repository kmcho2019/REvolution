module ROM (
    input clk,          // Clock for output register
    input en,           // Enable signal
    input [7:0] addr,   // 8-bit address input
    output reg [15:0] dout // 16-bit registered output
);

    // Combinational read logic
    wire [15:0] dout_next;
    
    always @(*) begin
        if (en) begin
            case(addr)
                8'h00: dout_next = 16'hA0A0;
                8'h01: dout_next = 16'hB1B1;
                8'h02: dout_next = 16'hC2C2;
                8'h03: dout_next = 16'hD3D3;
                default: dout_next = 16'h0000;
            endcase
        end else begin
            dout_next = 16'h0000; // Output zero when disabled
        end
    end

    // Register the output
    always @(posedge clk) begin
        dout <= dout_next;
    end

endmodule