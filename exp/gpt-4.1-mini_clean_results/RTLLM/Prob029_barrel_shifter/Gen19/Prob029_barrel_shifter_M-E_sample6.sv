// 8-to-1 multiplexer module to select one bit out of 8 inputs based on a 3-bit select signal
module mux8X1 (
    input  wire [7:0] d,    // 8-bit input bus, each bit candidate for output
    input  wire [2:0] sel,  // 3-bit select signal, selects which input bit is output
    output wire       y     // output bit selected from d
);
    // combinational mux using a case statement
    reg y_reg;
    always @(*) begin
        case(sel)
            3'd0: y_reg = d[0];
            3'd1: y_reg = d[1];
            3'd2: y_reg = d[2];
            3'd3: y_reg = d[3];
            3'd4: y_reg = d[4];
            3'd5: y_reg = d[5];
            3'd6: y_reg = d[6];
            3'd7: y_reg = d[7];
            default: y_reg = 1'b0;  // default safe value
        endcase
    end
    assign y = y_reg;
endmodule


module barrel_shifter (
    input  wire [7:0] in,       // 8-bit input to shift/rotate
    input  wire [2:0] ctrl,     // control bits: ctrl[0]=shift by 1, ctrl[1]=shift by 2, ctrl[2]=shift by 4
    output wire [7:0] out       // 8-bit rotated output
);

    // Calculate the total rotation amount as an integer 0-7 by summing weighted control bits
    wire [2:0] rotate_amt;
    assign rotate_amt = ctrl[0] + (ctrl[1] << 1) + (ctrl[2] << 2);

    genvar i;
    generate
        // For each output bit i, build the vector of candidate bits from input for rotation indices (0-7)
        for (i = 0; i < 8; i = i + 1) begin : gen_rotate_bits
            // Construct an 8-bit vector of input bits rotated by 0..7 positions relative to output bit i
            // The bit for rotation k is in[(i + k) % 8], so data[k] = in[(i + k) mod 8]
            wire [7:0] rotated_candidates;
            // generate rotated candidates by modular indexing
            // Since 'i' is constant per generate instance, indices are known constants
            assign rotated_candidates[0] = in[(i + 0) & 3'b111];
            assign rotated_candidates[1] = in[(i + 1) & 3'b111];
            assign rotated_candidates[2] = in[(i + 2) & 3'b111];
            assign rotated_candidates[3] = in[(i + 3) & 3'b111];
            assign rotated_candidates[4] = in[(i + 4) & 3'b111];
            assign rotated_candidates[5] = in[(i + 5) & 3'b111];
            assign rotated_candidates[6] = in[(i + 6) & 3'b111];
            assign rotated_candidates[7] = in[(i + 7) & 3'b111];

            // Instantiate mux8X1 to select the proper rotated bit based on rotate_amt
            mux8X1 mux_inst (
                .d(rotated_candidates),
                .sel(rotate_amt),
                .y(out[i])
            );
        end
    endgenerate

endmodule