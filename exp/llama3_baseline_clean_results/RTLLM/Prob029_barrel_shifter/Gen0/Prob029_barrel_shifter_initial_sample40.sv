// Define a 2-to-1 multiplexer submodule
module mux2X1(sel, in0, in1, out);
    input sel, in0, in1;
    output out;
    reg out;
    
    always @(sel, in0, in1)
        out = sel ? in1 : in0;
endmodule

// Define the barrel shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;
    reg [7:0] out;
    reg [7:0] stage1_out, stage2_out, stage3_out;
    reg [7:0] shifted_by_4, shifted_by_2, shifted_by_1;
    
    // Shift by 4 positions
    assign shifted_by_4 = {in[3:0], 4'b0000};
    
    // Stage 1: Shift by 4 positions
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            mux2X1 #(.WIDTH(1)) mux_stage1(
                .sel(ctrl[2]),
                .in0(in[i]),
                .in1(shifted_by_4[i]),
                .out(stage1_out[i])
            );
        end
    endgenerate
    
    // Shift by 2 positions
    assign shifted_by_2 = {in[6:0], 2'b00};
    
    // Stage 2: Shift by 2 positions
    generate
        for (i = 0; i < 8; i++) begin
            mux2X1 #(.WIDTH(1)) mux_stage2(
                .sel(ctrl[1]),
                .in0(stage1_out[i]),
                .in1(shifted_by_2[i]),
                .out(stage2_out[i])
            );
        end
    endgenerate
    
    // Shift by 1 position
    assign shifted_by_1 = {in[7:0], 1'b0};
    
    // Stage 3: Shift by 1 position
    generate
        for (i = 0; i < 8; i++) begin
            mux2X1 #(.WIDTH(1)) mux_stage3(
                .sel(ctrl[0]),
                .in0(stage2_out[i]),
                .in1(shifted_by_1[i]),
                .out(stage3_out[i])
            );
        end
    endgenerate
    
    // Assign the final output
    always @(stage3_out)
        out = stage3_out;
endmodule