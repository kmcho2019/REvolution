module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 32
) (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [DATA_WIDTH-1:0] adda,
    input wire [DATA_WIDTH-1:0] addb,
    output wire [DATA_WIDTH:0] result,
    output reg o_en
);

// Pipeline registers
reg carry;
reg [DATA_WIDTH-1:0] adda_pipe, addb_pipe;
reg [1:0] en_pipe;

// Stage 1: Add lower STG_WIDTH bits
wire [STG_WIDTH:0] sum_lower = adda[STG_WIDTH-1:0] + addb[STG_WIDTH-1:0];

// Stage 2: Add upper bits with carry
wire [DATA_WIDTH-STG_WIDTH:0] sum_upper = adda_pipe[DATA_WIDTH-1:STG_WIDTH] + 
                                         addb_pipe[DATA_WIDTH-1:STG_WIDTH] + 
                                         carry;

// Final result combination
assign result = {sum_upper, sum_lower[STG_WIDTH-1:0]};

// Pipeline control logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        carry <= 1'b0;
        adda_pipe <= {DATA_WIDTH{1'b0}};
        addb_pipe <= {DATA_WIDTH{1'b0}};
        en_pipe <= 2'b0;
        o_en <= 1'b0;
    end else begin
        carry <= sum_lower[STG_WIDTH];
        adda_pipe <= adda;
        addb_pipe <= addb;
        en_pipe <= {en_pipe[0], i_en};
        o_en <= en_pipe[1];
    end
end

endmodule