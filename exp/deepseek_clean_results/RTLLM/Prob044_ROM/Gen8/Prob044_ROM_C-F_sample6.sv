module ROM #(
    parameter DATA_WIDTH = 16,
    parameter ADDR_WIDTH = 8
)(
    input [ADDR_WIDTH-1:0] addr,
    input oe, // Output enable (active high)
    output reg [DATA_WIDTH-1:0] dout
);

    // Memory array declaration
    reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    // Initialize specific memory locations
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
    end

    // Output with enable control
    always @(*) begin
        dout = oe ? mem[addr] : {DATA_WIDTH{1'bz}};
    end

endmodule