// Define a module for a single ripple carry adder stage
module adder_stage(
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
);
    assign sum = a + b + cin;
    assign cout = (a[15] & b[15]) | (a[15] & cin) | (b[15] & cin);
endmodule

// Define the main adder module
module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Define the number of pipeline stages
parameter STAGES = 4;

// Define the width of each stage
parameter STAGE_WIDTH = 16;

// Calculate the total number of bits in the adder
parameter TOTAL_BITS = 64;

// Define the token signal
reg [STAGES-1:0] token;

// Define the input registers
reg [63:0] adda_reg;
reg [63:0] addb_reg;

// Define the output register
reg [64:0] result_reg;

// Define the output enable signal
reg o_en_reg;

// Define the state machine for the pipeline
reg [1:0] state;

// Combinational logic for the next state
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00;
        token <= {STAGES{1'b0}};
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        result_reg <= 65'd0;
        o_en_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin
                if (i_en) begin
                    state <= 2'b01;
                    token[0] <= 1'b1;
                    adda_reg <= adda;
                    addb_reg <= addb;
                end
            end
            2'b01: begin
                if (token[0]) begin
                    token[1] <= 1'b1;
                    state <= 2'b10;
                end
            end
            2'b10: begin
                if (token[1]) begin
                    token[2] <= 1'b1;
                    state <= 2'b11;
                end
            end
            2'b11: begin
                if (token[2]) begin
                    token[3] <= 1'b1;
                    state <= 2'b00;
                    o_en_reg <= 1'b1;
                end
            end
        endcase
    end
end

// Define the stages of the adder
reg [15:0] stage1_sum;
reg stage1_cout;
reg [15:0] stage2_sum;
reg stage2_cout;
reg [15:0] stage3_sum;
reg stage3_cout;
reg [15:0] stage4_sum;
reg stage4_cout;

always @(posedge clk) begin
    if (token[0]) begin
        adder_stage u1(.a(adda_reg[15:0]), .b(addb_reg[15:0]), .cin(1'b0), .sum(stage1_sum), .cout(stage1_cout));
    end
    if (token[1]) begin
        adder_stage u2(.a(adda_reg[31:16]), .b(addb_reg[31:16]), .cin(stage1_cout), .sum(stage2_sum), .cout(stage2_cout));
    end
    if (token[2]) begin
        adder_stage u3(.a(adda_reg[47:32]), .b(addb_reg[47:32]), .cin(stage2_cout), .sum(stage3_sum), .cout(stage3_cout));
    end
    if (token[3]) begin
        adder_stage u4(.a(adda_reg[63:48]), .b(addb_reg[63:48]), .cin(stage3_cout), .sum(stage4_sum), .cout(stage4_cout));
        result_reg <= {stage4_cout, stage4_sum, stage3_sum, stage2_sum, stage1_sum};
    end
end

assign result = result_reg;
assign o_en = o_en_reg;

endmodule