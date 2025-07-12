module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Define the population count for each byte
wire [7:0] pc_bytes [31:0];
genvar i;
generate
    for (i = 0; i < 32; i = i + 1) begin: byte_pc
        // Count the number of '1's in the current byte
        assign pc_bytes[i] = {8{in[8*i+7]} & 8'b1} + 
                              {8{in[8*i+6]} & 8'b1} + 
                              {8{in[8*i+5]} & 8'b1} + 
                              {8{in[8*i+4]} & 8'b1} + 
                              {8{in[8*i+3]} & 8'b1} + 
                              {8{in[8*i+2]} & 8'b1} + 
                              {8{in[8*i+1]} & 8'b1} + 
                              {8{in[8*i+0]} & 8'b1};
    end
endgenerate

// Add up the counts from each byte
wire [10:0] pc_total;
assign pc_total = pc_bytes[0] + pc_bytes[1] + pc_bytes[2] + pc_bytes[3] + 
                  pc_bytes[4] + pc_bytes[5] + pc_bytes[6] + pc_bytes[7] + 
                  pc_bytes[8] + pc_bytes[9] + pc_bytes[10] + pc_bytes[11] + 
                  pc_bytes[12] + pc_bytes[13] + pc_bytes[14] + pc_bytes[15] + 
                  pc_bytes[16] + pc_bytes[17] + pc_bytes[18] + pc_bytes[19] + 
                  pc_bytes[20] + pc_bytes[21] + pc_bytes[22] + pc_bytes[23] + 
                  pc_bytes[24] + pc_bytes[25] + pc_bytes[26] + pc_bytes[27] + 
                  pc_bytes[28] + pc_bytes[29] + pc_bytes[30] + pc_bytes[31];

// Output the population count
assign out = pc_total[7:0];

endmodule