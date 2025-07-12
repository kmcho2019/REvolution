module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Split the 8-bit selector into block selector (4 bits) and address (4 bits)
wire [3:0] block_sel = sel[7:4];
wire [3:0] addr = sel[3:0];

// Define an array to store the 16 memory blocks of 64 bits each
wire [63:0] mem_block [15:0];

// Use a for loop to assign the input vector to the memory blocks
genvar i;
for (i = 0; i < 16; i++) begin
    assign mem_block[i] = in[(i * 64) +: 64];
end

// Use a case statement to select the correct memory block
wire [63:0] selected_block;
always @(*) begin
    case (block_sel)
        4'h0: selected_block = mem_block[0];
        4'h1: selected_block = mem_block[1];
        4'h2: selected_block = mem_block[2];
        4'h3: selected_block = mem_block[3];
        4'h4: selected_block = mem_block[4];
        4'h5: selected_block = mem_block[5];
        4'h6: selected_block = mem_block[6];
        4'h7: selected_block = mem_block[7];
        4'h8: selected_block = mem_block[8];
        4'h9: selected_block = mem_block[9];
        4'hA: selected_block = mem_block[10];
        4'hB: selected_block = mem_block[11];
        4'hC: selected_block = mem_block[12];
        4'hD: selected_block = mem_block[13];
        4'hE: selected_block = mem_block[14];
        4'hF: selected_block = mem_block[15];
        default: selected_block = mem_block[0];
    endcase
end

// Use indexing to select the correct 4-bit value from the chosen block
assign out = selected_block[(addr * 4) +: 4];

endmodule