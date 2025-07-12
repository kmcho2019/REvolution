module TopModule (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // Stage 1: Combine first three inputs
    wire [14:0] stage1 = {a, b, c};
    
    // Stage 2: Combine next three inputs
    wire [14:0] stage2 = {d, e, f};
    
    // Final combination with padding bits
    wire [31:0] final_concat = {stage1, stage2, 2'b11};
    
    // Output assignments
    assign w = final_concat[31:24];
    assign x = final_concat[23:16];
    assign y = final_concat[15:8];
    assign z = final_concat[7:0];

endmodule