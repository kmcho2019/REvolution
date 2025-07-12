module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline registers
    reg [15:0] stage1_pp [0:3];  // Partial products
    reg [15:0] stage2_sum, stage2_carry;
    reg [1:0] pipeline_ctr;

    // Sign-extended inputs
    wire [15:0] a_ext = {{8{a[7]}}, a};
    wire [15:0] b_ext = {{8{b[7]}}, b};

    // Booth encoders (parallel processing)
    wire [15:0] pp0, pp1, pp2, pp3;
    booth_encoder be0(.a(a_ext), .b_group({b_ext[1:0], 1'b0}), .pp(pp0));
    booth_encoder be1(.a(a_ext), .b_group(b_ext[3:1]), .pp(pp1));
    booth_encoder be2(.a(a_ext), .b_group(b_ext[5:3]), .pp(pp2));
    booth_encoder be3(.a(a_ext), .b_group(b_ext[7:5]), .pp(pp3));

    // 4:2 compressor for partial product reduction
    wire [15:0] csa_sum, csa_carry;
    compressor_4to2 csa(
        .in0(pp0), 
        .in1(pp1 << 2), 
        .in2(pp2 << 4), 
        .in3(pp3 << 6),
        .sum_out(csa_sum),
        .carry_out(csa_carry)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Clear pipeline
            stage1_pp[0] <= 16'b0; stage1_pp[1] <= 16'b0;
            stage1_pp[2] <= 16'b0; stage1_pp[3] <= 16'b0;
            stage2_sum <= 16'b0; stage2_carry <= 16'b0;
            p <= 16'b0;
            pipeline_ctr <= 2'b0;
            rdy <= 1'b0;
        end else begin
            // Pipeline stage 1: Booth encoding
            stage1_pp[0] <= pp0;
            stage1_pp[1] <= pp1 << 2;
            stage1_pp[2] <= pp2 << 4;
            stage1_pp[3] <= pp3 << 6;

            // Pipeline stage 2: CSA reduction
            stage2_sum <= csa_sum;
            stage2_carry <= csa_carry;

            // Pipeline stage 3: Final addition
            p <= stage2_sum + (stage2_carry << 1);

            // Pipeline control
            pipeline_ctr <= pipeline_ctr + 1;
            rdy <= (pipeline_ctr == 2'b10) ? 1'b1 : 1'b0;
        end
    end

endmodule

// Radix-4 Booth encoder module
module booth_encoder(
    input [15:0] a,
    input [2:0] b_group,  // {current bit, previous bit}
    output reg [15:0] pp
);
    always @(*) begin
        case (b_group)
            3'b000, 3'b111: pp = 16'b0;
            3'b001, 3'b010: pp = a;
            3'b011:         pp = a << 1;
            3'b100:         pp = -(a << 1);
            3'b101, 3'b110: pp = -a;
        endcase
    end
endmodule

// 4:2 compressor module
module compressor_4to2(
    input [15:0] in0, in1, in2, in3,
    output [15:0] sum_out, carry_out
);
    wire [15:0] s1, c1, s2, c2;
    
    // First level of full adders
    assign s1 = in0 ^ in1 ^ in2;
    assign c1 = ((in0 & in1) | (in1 & in2) | (in2 & in0)) << 1;
    
    // Second level of full adders
    assign sum_out = s1 ^ in3 ^ c1;
    assign carry_out = ((s1 & in3) | (in3 & c1) | (c1 & s1)) << 1;
endmodule