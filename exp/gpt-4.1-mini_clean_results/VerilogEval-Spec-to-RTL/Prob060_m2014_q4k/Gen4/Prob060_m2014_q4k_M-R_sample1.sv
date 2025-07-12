module TopModule (
    input  clk,
    input  resetn,
    input  in,
    output out
);

    // Declare individual registers for each flip-flop stage
    reg stage0;
    reg stage1;
    reg stage2;
    reg stage3;

    // Sequential logic for each stage with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn) begin
            stage0 <= 1'b0;
            stage1 <= 1'b0;
            stage2 <= 1'b0;
            stage3 <= 1'b0;
        end else begin
            stage0 <= in;
            stage1 <= stage0;
            stage2 <= stage1;
            stage3 <= stage2;
        end
    end

    // Output is the last stage
    assign out = stage3;

endmodule