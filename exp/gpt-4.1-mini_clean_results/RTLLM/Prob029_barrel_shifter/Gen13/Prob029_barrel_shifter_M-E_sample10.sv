module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output reg  [7:0] out
);

    reg [7:0] stage0;
    reg [7:0] stage1;

    always @(*) begin
        // Stage 0: rotate by 4 if ctrl[2] == 1
        if (ctrl[2]) begin
            stage0 = {in[3:0], in[7:4]};
        end else begin
            stage0 = in;
        end

        // Stage 1: rotate by 2 if ctrl[1] == 1
        if (ctrl[1]) begin
            stage1 = {stage0[5:0], stage0[7:6]};
        end else begin
            stage1 = stage0;
        end

        // Stage 2: rotate by 1 if ctrl[0] == 1
        if (ctrl[0]) begin
            out = {stage1[6:0], stage1[7]};
        end else begin
            out = stage1;
        end
    end

endmodule