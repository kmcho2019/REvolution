// 1-bit full adder module
module full_adder(
    input   wire    a,
    input   wire    b,
    input   wire    cin,
    output  wire    sum,
    output  wire    cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 64-bit ripple carry adder module with pipeline stages
module adder_pipe_64bit(
    input   wire            clk,
    input   wire            rst_n,
    input   wire            i_en,
    input   wire    [63:0]  adda,
    input   wire    [63:0]  addb,
    output  reg     [64:0]  result,
    output  reg             o_en
);

    reg [63:0]  stage1_sum;
    reg         stage1_cout;
    reg [63:0]  stage2_sum;
    reg         stage2_cout;

    // Pipeline stage 1
    full_adder u_full_adder_0(
       .a(adda[0]),
       .b(addb[0]),
       .cin(1'b0),
       .sum(stage1_sum[0]),
       .cout(stage1_cout)
    );
    generate
        for (genvar i = 1; i < 64; i++) begin
            full_adder u_full_adder(
               .a(adda[i]),
               .b(addb[i]),
               .cin(stage1_sum[i-1]? 1'b1 : stage1_cout? 1'b1 : 1'b0),
               .sum(stage1_sum[i]),
               .cout(stage1_cout)
            );
        end
    endgenerate

    // Pipeline stage 2
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            stage2_sum <= '0;
            stage2_cout <= 1'b0;
        end else if (i_en) begin
            stage2_sum <= stage1_sum;
            stage2_cout <= stage1_cout;
        end
    end

    // Final sum calculation
    assign result[63:0] = stage2_sum;
    assign result[64] = stage2_cout;

    // Output enable signal
    reg [1:0]  pipe_en;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            pipe_en <= '0;
            o_en <= 1'b0;
        end else begin
            pipe_en[0] <= i_en;
            pipe_en[1] <= pipe_en[0];
            o_en <= pipe_en[1];
        end
    end

endmodule