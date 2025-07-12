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

// Instantiate the pipeline stages
genvar i;
generate
    for (i = 0; i < STAGES; i++) begin
        adder_stage #(.WIDTH(STAGE_WIDTH)) stage(
           .clk(clk),
           .rst_n(rst_n),
           .i_en(token[i]),
           .adda(adda_reg[(i+1)*STAGE_WIDTH-1:i*STAGE_WIDTH]),
           .addb(addb_reg[(i+1)*STAGE_WIDTH-1:i*STAGE_WIDTH]),
           .result(result_reg[(i+1)*STAGE_WIDTH-1:i*STAGE_WIDTH]),
           .o_en(token[i+1])
        );
    end
endgenerate

// Define the combinational logic for the final result
assign result = result_reg;

// Define the sequential logic for the output enable signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_en_reg <= 1'b0;
    end else if (token[STAGES-1]) begin
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

// Define the sequential logic for the token signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        token <= {STAGES{1'b0}};
    end else if (i_en) begin
        token <= {1'b1, token[STAGES-1:1]};
    end else begin
        token <= {STAGES{1'b0}};
    end
end

// Define the sequential logic for the input registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
    end else begin
        adda_reg <= adda_reg;
        addb_reg <= addb_reg;
    end
end

// Define the sequential logic for the output register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result_reg <= 65'd0;
    end else if (token[STAGES-1]) begin
        result_reg <= result_reg;
    end else begin
        result_reg <= {1'b0, adda_reg} + {1'b0, addb_reg};
    end
end

// Assign the output enable signal
assign o_en = o_en_reg;

endmodule

// Define the adder stage module
module adder_stage(
    input clk,
    input rst_n,
    input i_en,
    input [15:0] adda,
    input [15:0] addb,
    output [16:0] result,
    output o_en
);

// Define the combinational logic for the result
assign result = {1'b0, adda} + {1'b0, addb};

// Define the sequential logic for the output enable signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_en <= 1'b0;
    end else if (i_en) begin
        o_en <= 1'b1;
    end else begin
        o_en <= 1'b0;
    end
end

endmodule