module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers
reg [63:0] adda_pipe [0:7];
reg [63:0] addb_pipe [0:7];
reg [7:0] carry_pipe [0:7];
reg [7:0] sum_pipe [0:7];
reg [7:0] en_pipe;

// Internal signals
wire [7:0] carry_in [0:7];
wire [7:0] sum [0:7];

// Generate pipeline stages
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : pipeline_stages
        // First stage
        if (i == 0) begin
            assign {carry_in[0], sum[0]} = adda[7:0] + addb[7:0] + 1'b0;
            
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    adda_pipe[0] <= 64'b0;
                    addb_pipe[0] <= 64'b0;
                    carry_pipe[0] <= 8'b0;
                    sum_pipe[0] <= 8'b0;
                end else begin
                    adda_pipe[0] <= adda;
                    addb_pipe[0] <= addb;
                    carry_pipe[0] <= {7'b0, carry_in[0]};
                    sum_pipe[0] <= sum[0];
                end
            end
        end
        // Subsequent stages
        else begin
            assign {carry_in[i], sum[i]} = adda_pipe[i-1][(i*8)+7:i*8] + 
                                          addb_pipe[i-1][(i*8)+7:i*8] + 
                                          carry_pipe[i-1][i-1];
            
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    adda_pipe[i] <= 64'b0;
                    addb_pipe[i] <= 64'b0;
                    carry_pipe[i] <= 8'b0;
                    sum_pipe[i] <= 8'b0;
                end else begin
                    adda_pipe[i] <= adda_pipe[i-1];
                    addb_pipe[i] <= addb_pipe[i-1];
                    carry_pipe[i] <= {carry_pipe[i-1][6:0], carry_in[i]};
                    sum_pipe[i] <= sum[i];
                end
            end
        end
    end
endgenerate

// Enable signal pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        en_pipe <= 8'b0;
    end else begin
        en_pipe <= {en_pipe[6:0], i_en};
    end
end

// Final output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        result <= {carry_pipe[7][7], sum_pipe[7], sum_pipe[6], sum_pipe[5], 
                  sum_pipe[4], sum_pipe[3], sum_pipe[2], sum_pipe[1], sum_pipe[0]};
        o_en <= en_pipe[7];
    end
end

endmodule