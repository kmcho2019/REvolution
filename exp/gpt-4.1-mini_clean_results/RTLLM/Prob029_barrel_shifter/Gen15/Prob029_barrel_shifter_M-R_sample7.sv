module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Stage 1: shift by 4 if ctrl[2] is set
    wire [7:0] stage1;
    assign stage1 = {
        ctrl[2] ? in[3] : in[7],
        ctrl[2] ? in[2] : in[6],
        ctrl[2] ? in[1] : in[5],
        ctrl[2] ? in[0] : in[4],
        ctrl[2] ? in[7] : in[3],
        ctrl[2] ? in[6] : in[2],
        ctrl[2] ? in[5] : in[1],
        ctrl[2] ? in[4] : in[0]
    };

    // Stage 2: shift by 2 if ctrl[1] is set
    wire [7:0] stage2;
    assign stage2 = {
        ctrl[1] ? stage1[5] : stage1[7],
        ctrl[1] ? stage1[4] : stage1[6],
        ctrl[1] ? stage1[7] : stage1[5],
        ctrl[1] ? stage1[6] : stage1[4],
        ctrl[1] ? stage1[1] : stage1[3],
        ctrl[1] ? stage1[0] : stage1[2],
        ctrl[1] ? stage1[3] : stage1[1],
        ctrl[1] ? stage1[2] : stage1[0]
    };

    // Stage 3: shift by 1 if ctrl[0] is set
    assign out = {
        ctrl[0] ? stage2[6] : stage2[7],
        ctrl[0] ? stage2[5] : stage2[6],
        ctrl[0] ? stage2[4] : stage2[5],
        ctrl[0] ? stage2[3] : stage2[4],
        ctrl[0] ? stage2[2] : stage2[3],
        ctrl[0] ? stage2[1] : stage2[2],
        ctrl[0] ? stage2[0] : stage2[1],
        ctrl[0] ? stage2[7] : stage2[0]
    };

endmodule