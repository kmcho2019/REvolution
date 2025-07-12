module ROM (
    input [7:0] addr,
    input read_en,         // Added read enable signal
    output reg [15:0] dout
);

    // Continuous read operation with enable
    always @(*) begin
        if (read_en) begin
            case (addr[1:0])  // Only need 2 bits for 4 locations
                2'b00: dout = 16'hA0A0;
                2'b01: dout = 16'hB1B1;
                2'b10: dout = 16'hC2C2;
                2'b11: dout = 16'hD3D3;
                default: dout = 16'h0000;
            endcase
        end else begin
            dout = 16'h0000;  // Output zeros when not reading
        end
    end

endmodule