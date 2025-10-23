module ROM (
    input [7:0] addr,
    output reg [15:0] dout
);

    parameter DEFAULT_VAL = 16'h0000;
    
    // Continuous read operation with case-based lookup
    always @(*) begin
        case (addr)
            8'h00: dout = 16'hA0A0;
            8'h01: dout = 16'hB1B1;
            8'h02: dout = 16'hC2C2;
            8'h03: dout = 16'hD3D3;
            default: dout = DEFAULT_VAL;
        endcase
    end

    // Alternative implementation comment:
    // This approach eliminates the need for a physical memory array
    // and instead uses direct pattern matching, which may synthesize
    // more efficiently for small ROMs or sparse data patterns
endmodule