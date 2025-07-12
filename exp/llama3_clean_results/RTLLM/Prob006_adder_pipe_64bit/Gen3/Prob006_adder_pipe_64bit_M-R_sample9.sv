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

// Sequential logic for the token signal, input registers, and output register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        token <= {STAGES{1'b0}};
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        result_reg <= 65'd0;
        o_en_reg <= 1'b0;
    end else begin
        if (i_en) begin
            token[0] <= 1'b1;
            adda_reg <= adda;
            addb_reg <= addb;
        end
        for (int i = 0; i < STAGES - 1; i++) begin
            if (token[i]) begin
                token[i + 1] <= 1'b1;
            end
        end
        if (token[STAGES - 1]) begin
            o_en_reg <= 1'b1;
        end else begin
            o_en_reg <= 1'b0;
        end
        // Calculate the result
        result_reg <= {1'b0, adda_reg} + {1'b0, addb_reg};
    end
end

// Combinational logic for the result
assign result = result_reg;

// Assign the output enable signal
assign o_en = o_en_reg;

endmodule