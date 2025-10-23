module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] stage1_res;
reg [N-1:0] stage2_res;

// Stage 1: Sign detection and zero handling
always @(a or b) begin
    if (a == 0 || b == 0) begin
        stage1_res = 0;
    end else if (a[N-1] == b[N-1]) begin
        stage1_res = a - b;
    end else begin
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin
            stage1_res = a + (~b + 1'b1);
        end else begin
            stage1_res = (~a + 1'b1) + b;
        end
    end
end

// Stage 2: Subtraction or addition operation
always @(stage1_res) begin
    if (stage1_res[N-1] == 1'b0) begin
        stage2_res = stage1_res;
    end else begin
        stage2_res = ~stage1_res + 1'b1;
    end
end

// Stage 3: Result formatting and output
always @(stage2_res) begin
    if (stage2_res == 0) begin
        c = {N{1'b0}};
    end else begin
        c = stage2_res;
    end
end

endmodule