module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

// Define the number of quadrants
parameter NUM_QUADRANTS = 4;

// Calculate the address mask for each quadrant
parameter QUADRANT_MASK = (ADDR_WIDTH - $clog2(NUM_QUADRANTS));

// ROM submodules
reg [DATA_WIDTH-1:0] mem_quadrant [NUM_QUADRANTS-1:0][0:2**QUADRANT_MASK-1];

// Initial block to initialize each quadrant
initial begin
    // Quadrant 0
    mem_quadrant[0][0] = 16'hA0A0;
    mem_quadrant[0][1] = 16'hB1B1;
    mem_quadrant[0][2] = 16'hC2C2;
    mem_quadrant[0][3] = 16'hD3D3;
    
    // Quadrant 1
    mem_quadrant[1][0] = 16'hE4E4;
    mem_quadrant[1][1] = 16'hF5F5;
    mem_quadrant[1][2] = 16'hG6G6;
    mem_quadrant[1][3] = 16'hH7H7;
    
    // Quadrant 2
    mem_quadrant[2][0] = 16'hI8I8;
    mem_quadrant[2][1] = 16'hJ9J9;
    mem_quadrant[2][2] = 16'hK10K10;
    mem_quadrant[2][3] = 16'hL11L11;
    
    // Quadrant 3
    mem_quadrant[3][0] = 16'hM12M12;
    mem_quadrant[3][1] = 16'hN13N13;
    mem_quadrant[3][2] = 16'hO14O14;
    mem_quadrant[3][3] = 16'hP15P15;
end

// Arbiter logic to select the correct quadrant
reg [1:0] quadrant_select;

always @(*) begin
    case (addr[ADDR_WIDTH-1:QUADRANT_MASK])
        2'b00: quadrant_select = 2'b00;
        2'b01: quadrant_select = 2'b01;
        2'b10: quadrant_select = 2'b10;
        2'b11: quadrant_select = 2'b11;
    endcase
end

// Output logic to select data from the correct quadrant
always @(*) begin
    case (quadrant_select)
        2'b00: dout = mem_quadrant[0][addr[QUADRANT_MASK-1:0]];
        2'b01: dout = mem_quadrant[1][addr[QUADRANT_MASK-1:0]];
        2'b10: dout = mem_quadrant[2][addr[QUADRANT_MASK-1:0]];
        2'b11: dout = mem_quadrant[3][addr[QUADRANT_MASK-1:0]];
    endcase
end

endmodule