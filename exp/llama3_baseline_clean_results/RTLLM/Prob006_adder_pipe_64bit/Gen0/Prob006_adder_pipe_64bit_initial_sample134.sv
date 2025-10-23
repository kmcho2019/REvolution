module adder_pipe_64bit (
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Define internal signals
reg [63:0] stage1_a;
reg [63:0] stage1_b;
reg [63:0] stage2_sum;
reg [0:0] stage2_cout;
reg [64:0] stage3_result;
reg i_en_sync;

// Pipeline stage 1: Input operand registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_a <= 64'd0;
        stage1_b <= 64'd0;
    end else if (i_en) begin
        stage1_a <= adda;
        stage1_b <= addb;
    end
end

// Pipeline stage 2: Ripple carry adder
wire [63:0] stage2_sum_wire;
wire [0:0] stage2_cout_wire;
ripple_carry_adder rca_stage2 (
    .a(stage1_a),
    .b(stage1_b),
    .cin(1'b0),
    .sum(stage2_sum_wire),
    .cout(stage2_cout_wire)
);
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_sum <= 64'd0;
        stage2_cout <= 1'b0;
    end else begin
        stage2_sum <= stage2_sum_wire;
        stage2_cout <= stage2_cout_wire;
    end
end

// Pipeline stage 3: Final result register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage3_result <= 65'd0;
    end else begin
        stage3_result <= {stage2_cout, stage2_sum};
    end
end

// Output enable signal synchronization
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i_en_sync <= 1'b0;
    end else begin
        i_en_sync <= i_en;
    end
end

// Output assignments
assign result = stage3_result;
assign o_en = i_en_sync && (stage3_result != 65'd0);

endmodule

// Ripple carry adder module
module ripple_carry_adder (
    input [63:0] a,
    input [63:0] b,
    input cin,
    output [63:0] sum,
    output cout
);

// Define internal signals
wire [0:62] carry;

// Generate carry signals
genvar i;
generate
    for (i = 0; i < 63; i = i + 1) begin
        if (i == 0) begin
            full_adder fa0 (
                .a(a[0]),
                .b(b[0]),
                .cin(cin),
                .sum(sum[0]),
                .cout(carry[0])
            );
        end else begin
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i-1]),
                .sum(sum[i]),
                .cout(carry[i])
            );
        end
    end
endgenerate

// Final carry signal
full_adder fa63 (
    .a(a[63]),
    .b(b[63]),
    .cin(carry[62]),
    .sum(sum[63]),
    .cout(cout)
);

endmodule

// Full adder module
module full_adder (
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule