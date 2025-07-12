module ROM (
    input [7:0] addr,
    output reg [15:0] dout
);

    // ROM contents defined as parameters
    parameter [15:0] ROM_DATA [0:3] = '{
        16'hA0A0,  // addr 0
        16'hB1B1,  // addr 1
        16'hC2C2,  // addr 2
        16'hD3D3   // addr 3
    };

    always @(*) begin
        case (addr)
            8'd0: dout = ROM_DATA[0];
            8'd1: dout = ROM_DATA[1];
            8'd2: dout = ROM_DATA[2];
            8'd3: dout = ROM_DATA[3];
            default: dout = 16'h0000; // Default value for other addresses
        endcase
    end

endmodule