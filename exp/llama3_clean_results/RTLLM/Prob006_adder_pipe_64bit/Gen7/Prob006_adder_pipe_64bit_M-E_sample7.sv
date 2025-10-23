module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

// Define the number of pipeline stages
parameter STAGES = 4;
parameter WIDTH = 64;

// Define the width of each slice
parameter SLICE_WIDTH = WIDTH / STAGES;

reg [WIDTH:0] sum[0:STAGES-1];
reg [WIDTH:0] result_reg;
reg o_en_reg;

assign result = result_reg;
assign o_en = o_en_reg;

// Initialize the pipeline stages
integer i;
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < STAGES; i++) begin
            sum[i] <= {WIDTH+1{1'b0}};
        end
        result_reg <= {WIDTH+1{1'b0}};
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        // Perform the addition and capture the carry
        for (i = 0; i < STAGES; i++) begin
            sum[i] <= (i == 0) ? {1'b0, adda[WIDTH-1:WIDTH-SLICE_WIDTH]} + {1'b0, addb[WIDTH-1:WIDTH-SLICE_WIDTH]} :
                                  {sum[i-1][WIDTH], sum[i-1][WIDTH-1:0]} + {1'b0, adda[WIDTH-SLICE_WIDTH*(i+1)-1:WIDTH-SLICE_WIDTH*(i+2)]} + {1'b0, addb[WIDTH-SLICE_WIDTH*(i+1)-1:WIDTH-SLICE_WIDTH*(i+2)]};
        end
        // Store the result in the output buffer
        result_reg <= sum[STAGES-1];
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

endmodule