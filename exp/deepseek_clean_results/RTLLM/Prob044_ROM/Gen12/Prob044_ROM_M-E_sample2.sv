module ROM (
    input [7:0] addr,
    output reg [15:0] dout
);

    // Parameterized ROM contents
    parameter [15:0] ROM_CONTENTS [0:3] = '{
        16'hA0A0,
        16'hB1B1,
        16'hC2C2,
        16'hD3D3
    };

    always @(*) begin
        case (addr)
            8'h00: dout = ROM_CONTENTS[0];
            8'h01: dout = ROM_CONTENTS[1];
            8'h02: dout = ROM_CONTENTS[2];
            8'h03: dout = ROM_CONTENTS[3];
            default: dout = 16'hFFFF; // Default value for uninitialized addresses
        endcase
    end

endmodule