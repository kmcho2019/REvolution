module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output reg  [3:0]    out
);

    // Stage 1: Select one 4-bit input from each of the 16 groups, indexed by sel[3:0]
    // Each group consists of 16 4-bit inputs (16*4=64 bits per group)
    // There are 16 such groups (16*64=1024 bits)
    wire [3:0] stage1_out [0:15];

    genvar g;
    generate
        for (g = 0; g < 16; g = g + 1) begin : stage1_mux
            // Compute group base bit index: g * 64
            // Select 4 bits inside the group indexed by sel[3:0] * 4
            // Full bit offset: g*64 + sel[3:0]*4
            // Use a wire slice (partial select) with variable index - legal in SystemVerilog and many Verilog tools
            assign stage1_out[g] = in[g*64 + sel[3:0]*4 +: 4];
        end
    endgenerate

    // Stage 2: Select final 4-bit output from stage1_out indexed by sel[7:4]
    always @(*) begin
        case (sel[7:4])
            4'd0:  out = stage1_out[0];
            4'd1:  out = stage1_out[1];
            4'd2:  out = stage1_out[2];
            4'd3:  out = stage1_out[3];
            4'd4:  out = stage1_out[4];
            4'd5:  out = stage1_out[5];
            4'd6:  out = stage1_out[6];
            4'd7:  out = stage1_out[7];
            4'd8:  out = stage1_out[8];
            4'd9:  out = stage1_out[9];
            4'd10: out = stage1_out[10];
            4'd11: out = stage1_out[11];
            4'd12: out = stage1_out[12];
            4'd13: out = stage1_out[13];
            4'd14: out = stage1_out[14];
            4'd15: out = stage1_out[15];
            default: out = 4'b0;
        endcase
    end

endmodule