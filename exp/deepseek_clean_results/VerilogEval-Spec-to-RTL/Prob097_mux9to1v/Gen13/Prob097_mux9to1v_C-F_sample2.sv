module TopModule (
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output [15:0] out
);

parameter DEFAULT_VAL = 16'hFFFF;

// Early detection of invalid selection for power optimization
wire valid_sel = (sel < 9);

// Generate output bits in parallel with hierarchical selection
genvar bit_idx;
generate
    for (bit_idx = 0; bit_idx < 16; bit_idx = bit_idx + 1) begin: bit_loop
        reg selected_bit;
        
        always @(*) begin
            if (!valid_sel) begin
                selected_bit = 1'b1;  // Default value for invalid selections
            end else begin
                // Hierarchical case structure for better timing
                case (sel[2:0])
                    3'd0: selected_bit = (sel[3]) ? i[bit_idx] : a[bit_idx];
                    3'd1: selected_bit = b[bit_idx];
                    3'd2: selected_bit = c[bit_idx];
                    3'd3: selected_bit = d[bit_idx];
                    3'd4: selected_bit = e[bit_idx];
                    3'd5: selected_bit = f[bit_idx];
                    3'd6: selected_bit = g[bit_idx];
                    3'd7: selected_bit = h[bit_idx];
                endcase
            end
        end
        
        assign out[bit_idx] = selected_bit;
    end
endgenerate

endmodule