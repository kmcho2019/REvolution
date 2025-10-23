module ROM (
    input  wire        clk,
    input  wire [7:0]  addr,
    output reg  [15:0] dout
);

    always @(*) begin
        case (addr)
            8'h00: dout = 16'hA0A0;
            8'h01: dout = 16'hB1B1;
            8'h02: dout = 16'hC2C2;
            8'h03: dout = 16'hD3D3;
            default: dout = 16'h0000;
        endcase
    end

    // Register output to reduce combinational delay on dout
    reg [15:0] dout_reg;
    always @(posedge clk) begin
        dout_reg <= dout;
    end

    assign dout = dout_reg;

endmodule