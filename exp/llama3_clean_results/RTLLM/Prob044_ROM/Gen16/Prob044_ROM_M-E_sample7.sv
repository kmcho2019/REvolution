module ROM(
    input [7:0] addr,
    output reg [15:0] dout
);

// Divide the 256 locations into 4 sub-modules, each with 64 locations
reg [15:0] mem_0 [0:63];
reg [15:0] mem_1 [0:63];
reg [15:0] mem_2 [0:63];
reg [15:0] mem_3 [0:63];

// Initial block to pre-load the sub-modules with fixed data
initial begin
    // Sub-module 0
    mem_0[0] = 16'hA0A0;
    mem_0[1] = 16'hB1B1;
    mem_0[2] = 16'hC2C2;
    mem_0[3] = 16'hD3D3;
    
    // Sub-module 1
    mem_1[0] = 16'hE4E4;
    mem_1[1] = 16'hF5F5;
    mem_1[2] = 16'hG6G6;
    mem_1[3] = 16'hH7H7;
    
    // Sub-module 2
    mem_2[0] = 16'hI8I8;
    mem_2[1] = 16'hJ9J9;
    mem_2[2] = 16'hK10K10;
    mem_2[3] = 16'hL11L11;
    
    // Sub-module 3
    mem_3[0] = 16'hM12M12;
    mem_3[1] = 16'hN13N13;
    mem_3[2] = 16'hO14O14;
    mem_3[3] = 16'hP15P15;
end

// Always block to output the data from the selected sub-module
always @(*) begin
    case (addr[7:6])
        2'b00: dout = mem_0[addr[5:0]];
        2'b01: dout = mem_1[addr[5:0]];
        2'b10: dout = mem_2[addr[5:0]];
        2'b11: dout = mem_3[addr[5:0]];
        default: dout = 16'hXXXX;
    endcase
end

endmodule