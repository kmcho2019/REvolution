module ROM (
    input  wire [7:0]  addr,
    output reg  [15:0] dout
);

    always @(*) begin
        case(addr)
            8'd0: dout = 16'hA0A0;
            8'd1: dout = 16'hB1B1;
            8'd2: dout = 16'hC2C2;
            8'd3: dout = 16'hD3D3;
            default: dout = 16'h0000;
        endcase
    end

endmodule