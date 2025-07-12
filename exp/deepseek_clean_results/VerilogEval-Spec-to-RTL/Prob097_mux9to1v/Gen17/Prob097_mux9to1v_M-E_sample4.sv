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

// Early detection of invalid selection
wire invalid_sel = (sel >= 9);

// Generate selection masks
wire [8:0] sel_mask;
assign sel_mask[0] = (sel == 4'd0);  // a
assign sel_mask[1] = (sel == 4'd1);  // b
assign sel_mask[2] = (sel == 4'd2);  // c
assign sel_mask[3] = (sel == 4'd3);  // d
assign sel_mask[4] = (sel == 4'd4);  // e
assign sel_mask[5] = (sel == 4'd5);  // f
assign sel_mask[6] = (sel == 4'd6);  // g
assign sel_mask[7] = (sel == 4'd7);  // h
assign sel_mask[8] = (sel == 4'd8);  // i

// Combine inputs into a 2D array for parallel processing
wire [15:0] inputs [8:0];
assign inputs[0] = a;
assign inputs[1] = b;
assign inputs[2] = c;
assign inputs[3] = d;
assign inputs[4] = e;
assign inputs[5] = f;
assign inputs[6] = g;
assign inputs[7] = h;
assign inputs[8] = i;

// Generate output using bitwise masking
genvar bit_idx;
generate
    for (bit_idx = 0; bit_idx < 16; bit_idx = bit_idx + 1) begin: bit_loop
        reg out_bit;
        integer input_idx;
        
        always @(*) begin
            if (invalid_sel) begin
                out_bit = 1'b1;
            end else begin
                out_bit = 1'b0;
                for (input_idx = 0; input_idx < 9; input_idx = input_idx + 1) begin
                    out_bit = out_bit | (sel_mask[input_idx] & inputs[input_idx][bit_idx]);
                end
            end
        end
        
        assign out[bit_idx] = out_bit;
    end
endgenerate

endmodule