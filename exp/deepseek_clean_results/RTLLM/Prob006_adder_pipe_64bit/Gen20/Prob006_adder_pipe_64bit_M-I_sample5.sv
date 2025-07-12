module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 64
) (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [DATA_WIDTH-1:0] adda,
    input wire [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0] result,
    output reg o_en
);

// Parameter validation
initial begin
    if (DATA_WIDTH != 64) $warning("Non-standard DATA_WIDTH specified");
    if (STG_WIDTH != 64) $warning("STG_WIDTH parameter not fully utilized in current implementation");
end

// Pipeline registers
reg [DATA_WIDTH-1:0] a_reg, b_reg;

// Combinational addition
wire [DATA_WIDTH:0] sum = {1'b0, a_reg} + {1'b0, b_reg};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        a_reg <= {DATA_WIDTH{1'b0}};
        b_reg <= {DATA_WIDTH{1'b0}};
        result <= {(DATA_WIDTH+1){1'b0}};
        o_en <= 1'b0;
    end else begin
        // Stage 1: Register inputs
        if (i_en) begin
            a_reg <= adda;
            b_reg <= addb;
        end
        
        // Stage 2: Register result and generate output enable
        result <= sum;
        o_en <= i_en; // Directly use i_en since we have 2-stage pipeline
    end
end

endmodule