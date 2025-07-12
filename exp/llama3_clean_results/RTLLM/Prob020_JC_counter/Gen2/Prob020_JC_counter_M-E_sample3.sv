module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [63:0] lfsr;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lfsr <= 64'd0;
    end else begin
        // Johnson counter sequence generation using LFSR
        // The feedback taps are chosen to generate the desired sequence
        lfsr <= {lfsr[62], lfsr[61], lfsr[60], lfsr[59], lfsr[58], lfsr[57], lfsr[56], lfsr[55], lfsr[54], lfsr[53], lfsr[52], lfsr[51], lfsr[50], lfsr[49], lfsr[48], lfsr[47], lfsr[46], lfsr[45], lfsr[44], lfsr[43], lfsr[42], lfsr[41], lfsr[40], lfsr[39], lfsr[38], lfsr[37], lfsr[36], lfsr[35], lfsr[34], lfsr[33], lfsr[32], lfsr[31], lfsr[30], lfsr[29], lfsr[28], lfsr[27], lfsr[26], lfsr[25], lfsr[24], lfsr[23], lfsr[22], lfsr[21], lfsr[20], lfsr[19], lfsr[18], lfsr[17], lfsr[16], lfsr[15], lfsr[14], lfsr[13], lfsr[12], lfsr[11], lfsr[10], lfsr[9], lfsr[8], lfsr[7], lfsr[6], lfsr[5], lfsr[4], lfsr[3], lfsr[2], lfsr[1], lfsr[0] ^ lfsr[63]};
    end
end

assign Q = lfsr;

endmodule