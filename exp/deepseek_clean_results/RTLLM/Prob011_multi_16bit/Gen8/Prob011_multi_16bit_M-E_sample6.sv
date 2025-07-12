module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output done
);

// Partial product generation
wire [15:0] pp [15:0];
genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin : pp_gen
        assign pp[i] = ain & {16{bin[i]}};
    end
endgenerate

// Wallace tree reduction stages
wire [31:0] stage1 [7:0];
wire [31:0] stage2 [3:0];
wire [31:0] stage3 [1:0];
wire [31:0] sum, carry;

// Stage 1: 16 -> 8 reduction using 4:2 compressors
generate
    for (i = 0; i < 8; i = i + 1) begin : stage1_reduce
        compressor_4to2 c1 (
            .a(i*2 < 16 ? pp[i*2] << (i*2) : 32'b0),
            .b(i*2+1 < 16 ? pp[i*2+1] << (i*2+1) : 32'b0),
            .c(i*2+2 < 16 ? pp[i*2+2] << (i*2+2) : 32'b0),
            .d(i*2+3 < 16 ? pp[i*2+3] << (i*2+3) : 32'b0),
            .sum(stage1[i]),
            .carry()
        );
    end
endgenerate

// Stage 2: 8 -> 4 reduction
generate
    for (i = 0; i < 4; i = i + 1) begin : stage2_reduce
        compressor_4to2 c2 (
            .a(stage1[i*2]),
            .b(stage1[i*2+1]),
            .c(32'b0),
            .d(32'b0),
            .sum(stage2[i]),
            .carry()
        );
    end
endgenerate

// Stage 3: 4 -> 2 reduction
compressor_4to2 c3 (
    .a(stage2[0]),
    .b(stage2[1]),
    .c(stage2[2]),
    .d(stage2[3]),
    .sum(stage3[0]),
    .carry(stage3[1])
);

// Final adder (carry-select)
reg [31:0] sum_reg, carry_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg <= 32'b0;
        carry_reg <= 32'b0;
    end else if (start) begin
        sum_reg <= stage3[0];
        carry_reg <= stage3[1];
    end
end

wire [31:0] sum_c0, sum_c1;
assign sum_c0 = sum_reg + carry_reg;
assign sum_c1 = sum_reg + carry_reg + 1;

// Control logic
reg [1:0] state;
reg done_r;
localparam IDLE = 2'b00, PROCESS = 2'b01, DONE = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        done_r <= 1'b0;
        yout <= 32'b0;
    end else begin
        case (state)
            IDLE: begin
                if (start) state <= PROCESS;
                done_r <= 1'b0;
            end
            PROCESS: begin
                state <= DONE;
                yout <= (carry_reg[31]) ? sum_c1 : sum_c0;
            end
            DONE: begin
                done_r <= 1'b1;
                if (!start) state <= IDLE;
            end
        endcase
    end
end

assign done = done_r;

// 4:2 compressor module
module compressor_4to2 (
    input [31:0] a, b, c, d,
    output [31:0] sum, carry
);
    wire [31:0] s1 = a ^ b ^ c ^ d;
    wire [31:0] c1 = (a & b) | (c & d) | ((a | b) & (c | d));
    
    assign sum = s1;
    assign carry = c1 << 1;
endmodule

endmodule