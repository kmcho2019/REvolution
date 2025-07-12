module mux2X1 #(
    parameter WIDTH = 8
) (
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             sel,
    output wire [WIDTH-1:0] out
);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : mux_bits
            assign out[i] = sel ? b[i] : a[i];
        end
    endgenerate
endmodule

module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    wire [7:0] stage1_rot, stage2_rot, stage3_rot;
    
    // Rotate left by 1 bit function
    wire [7:0] in_rot1;
    assign in_rot1 = {in[6:0], in[7]};
    
    // Rotate left by 2 bits function
    wire [7:0] in_rot2;
    assign in_rot2 = {in[5:0], in[7:6]};
    
    // Rotate left by 4 bits function
    wire [7:0] in_rot4;
    assign in_rot4 = {in[3:0], in[7:4]};
    
    // Stage 1: Shift by 1 bit controlled by ctrl[0]
    mux2X1 #(.WIDTH(8)) mux1 (
        .a(in),
        .b(in_rot1),
        .sel(ctrl[0]),
        .out(stage1_rot)
    );
    
    // Compute rotated versions of stage1_rot for next stage
    wire [7:0] stage1_rot_rot2 = {stage1_rot[5:0], stage1_rot[7:6]};
    wire [7:0] stage1_rot_rot4 = {stage1_rot[3:0], stage1_rot[7:4]}; // not used here but clarifies
    
    // Stage 2: Shift by 2 bits controlled by ctrl[1]
    mux2X1 #(.WIDTH(8)) mux2 (
        .a(stage1_rot),
        .b(stage1_rot_rot2),
        .sel(ctrl[1]),
        .out(stage2_rot)
    );
    
    // Compute rotated versions of stage2_rot for next stage
    wire [7:0] stage2_rot_rot4 = {stage2_rot[3:0], stage2_rot[7:4]};
    
    // Stage 3: Shift by 4 bits controlled by ctrl[2]
    mux2X1 #(.WIDTH(8)) mux3 (
        .a(stage2_rot),
        .b(stage2_rot_rot4),
        .sel(ctrl[2]),
        .out(out)
    );
    
endmodule