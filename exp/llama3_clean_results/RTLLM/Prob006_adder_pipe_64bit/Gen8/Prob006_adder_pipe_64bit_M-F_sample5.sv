module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

// Define the number of pipeline stages and data width
parameter DATA_WIDTH = 64;
parameter STG_WIDTH = 4;

// Calculate the width of each slice
parameter SLICE_WIDTH = DATA_WIDTH / STG_WIDTH;

reg [DATA_WIDTH:0] sum[0:STG_WIDTH-1];
reg [DATA_WIDTH:0] result_reg;
reg o_en_reg;

assign result = result_reg;
assign o_en = o_en_reg;

// Initialize the pipeline stages
integer i;
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < STG_WIDTH; i++) begin
            sum[i] <= {DATA_WIDTH+1{1'b0}};
        end
        result_reg <= {DATA_WIDTH+1{1'b0}};
        o_en_reg <= 1'b0;
    end else begin
        if (i_en) begin
            // Perform the addition and capture the carry for each stage
            sum[0] <= {1'b0, adda[DATA_WIDTH-1:DATA_WIDTH-SLICE_WIDTH]} + {1'b0, addb[DATA_WIDTH-1:DATA_WIDTH-SLICE_WIDTH]};
            for (i = 1; i < STG_WIDTH; i++) begin
                sum[i] <= {sum[i-1][DATA_WIDTH], sum[i-1][DATA_WIDTH-1:0]} + {1'b0, adda[DATA_WIDTH-SLICE_WIDTH*(i+1)-1:WIDTH-SLICE_WIDTH*(i+2)]} + {1'b0, addb[DATA_WIDTH-SLICE_WIDTH*(i+1)-1:WIDTH-SLICE_WIDTH*(i+2)]};
            end
            // Store the result in the output buffer
            result_reg <= sum[STG_WIDTH-1];
            o_en_reg <= 1'b1;
        end else begin
            o_en_reg <= 1'b0;
        end
    end
end

endmodule