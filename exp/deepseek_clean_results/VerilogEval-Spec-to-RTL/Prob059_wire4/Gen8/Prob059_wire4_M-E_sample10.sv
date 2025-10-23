module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    // LUT-based implementation
    reg [3:0] lut [0:7];
    
    initial begin
        // Initialize LUT with all possible input combinations
        lut[3'b000] = 4'b0000;
        lut[3'b001] = 4'b0001;
        lut[3'b010] = 4'b0110;
        lut[3'b011] = 4'b0111;
        lut[3'b100] = 4'b1000;
        lut[3'b101] = 4'b1001;
        lut[3'b110] = 4'b1110;
        lut[3'b111] = 4'b1111;
    end
    
    wire [2:0] input_sel = {a, b, c};
    wire [3:0] output_vec;
    
    assign output_vec = lut[input_sel];
    assign {w, x, y, z} = output_vec;
endmodule