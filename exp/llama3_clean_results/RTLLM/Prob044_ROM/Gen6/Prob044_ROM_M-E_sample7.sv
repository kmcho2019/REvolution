module ROM(
    input [7:0] addr,
    output reg [15:0] dout
);

// Define the number of sub-arrays and their size
localparam NUM_SUB_ARRAYS = 4;
localparam SUB_ARRAY_SIZE = 64;

// Declare the sub-arrays
reg [15:0] mem [0:NUM_SUB_ARRAYS-1][0:SUB_ARRAY_SIZE-1];

// Initial block to pre-load the memory locations
initial begin
    // Initialize memory locations using a loop
    for (int i = 0; i < NUM_SUB_ARRAYS; i++) begin
        for (int j = 0; j < SUB_ARRAY_SIZE; j++) begin
            // Calculate the address and data value
            int addr_val = i * SUB_ARRAY_SIZE + j;
            reg [15:0] data_val;
            case (addr_val)
                0: data_val = 16'hA0A0;
                1: data_val = 16'hB1B1;
                2: data_val = 16'hC2C2;
                3: data_val = 16'hD3D3;
                default: data_val = 16'h0000; // Initialize other locations with zeros
            endcase
            mem[i][j] = data_val;
        end
    end
end

// Always block to output the data stored at the address specified by addr
always @(*) begin
    // Calculate the sub-array index and offset
    int sub_array_idx = addr[7:6];
    int offset = addr[5:0];
    // Select the appropriate sub-array and output the data
    case (sub_array_idx)
        0: dout = mem[0][offset];
        1: dout = mem[1][offset];
        2: dout = mem[2][offset];
        3: dout = mem[3][offset];
        default: dout = 16'h0000; // Default value for invalid addresses
    endcase
end

endmodule