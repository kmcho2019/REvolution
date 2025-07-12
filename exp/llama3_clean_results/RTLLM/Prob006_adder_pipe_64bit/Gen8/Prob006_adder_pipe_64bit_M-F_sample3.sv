module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 16
)(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [DATA_WIDTH-1:0]  adda,
    input   [DATA_WIDTH-1:0]  addb,
    output  [DATA_WIDTH:0]  result,
    output          o_en
);

reg [DATA_WIDTH-1:0] adda_reg;
reg [DATA_WIDTH-1:0] addb_reg;
reg [STG_WIDTH-1:0] seg_adda [(DATA_WIDTH/STG_WIDTH)-1:0];
reg [STG_WIDTH-1:0] seg_addb [(DATA_WIDTH/STG_WIDTH)-1:0];
reg [STG_WIDTH:0] seg_result [(DATA_WIDTH/STG_WIDTH)-1:0];
reg [0:0] carry [(DATA_WIDTH/STG_WIDTH)-1:0];
reg [0:0] en_pipe [(DATA_WIDTH/STG_WIDTH)-1:0];

// Input registers
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= {DATA_WIDTH{1'b0}};
        addb_reg <= {DATA_WIDTH{1'b0}};
        en_pipe[0] <= 1'b0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
        en_pipe[0] <= 1'b1;
    end else begin
        en_pipe[0] <= 1'b0;
    end
end

// Pipeline stages
genvar i;
generate
    for (i = 0; i < (DATA_WIDTH/STG_WIDTH); i++) begin
        always @ (posedge clk or negedge rst_n) begin
            if (~rst_n) begin
                seg_adda[i] <= {STG_WIDTH{1'b0}};
                seg_addb[i] <= {STG_WIDTH{1'b0}};
                if (i < (DATA_WIDTH/STG_WIDTH)-1) begin
                    en_pipe[i+1] <= 1'b0;
                end
            end else if (en_pipe[i]) begin
                seg_adda[i] <= adda_reg[(i+1)*STG_WIDTH-1:i*STG_WIDTH];
                seg_addb[i] <= addb_reg[(i+1)*STG_WIDTH-1:i*STG_WIDTH];
                if (i < (DATA_WIDTH/STG_WIDTH)-1) begin
                    en_pipe[i+1] <= 1'b1;
                end
            end else begin
                if (i < (DATA_WIDTH/STG_WIDTH)-1) begin
                    en_pipe[i+1] <= 1'b0;
                end
            end
        end
    end
endgenerate

// Segment adders and carry propagation
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < (DATA_WIDTH/STG_WIDTH); i++) begin
            seg_result[i] <= {STG_WIDTH+1{1'b0}};
            if (i < (DATA_WIDTH/STG_WIDTH)-1) begin
                carry[i] <= 1'b0;
            end
        end
    end else if (en_pipe[(DATA_WIDTH/STG_WIDTH)-1]) begin
        seg_result[0] <= {1'b0, seg_adda[0]} + {1'b0, seg_addb[0]};
        carry[0] <= (seg_adda[0][STG_WIDTH-1] & seg_addb[0][STG_WIDTH-1]) | ((seg_adda[0][STG_WIDTH-1] | seg_addb[0][STG_WIDTH-1]) & seg_result[0][STG_WIDTH-1]);
        for (int i = 1; i < (DATA_WIDTH/STG_WIDTH); i++) begin
            seg_result[i] <= {1'b0, seg_adda[i]} + {1'b0, seg_addb[i]} + {STG_WIDTH{1'b0}, carry[i-1]};
            if (i < (DATA_WIDTH/STG_WIDTH)-1) begin
                carry[i] <= (seg_adda[i][STG_WIDTH-1] & seg_addb[i][STG_WIDTH-1]) | ((seg_adda[i][STG_WIDTH-1] | seg_addb[i][STG_WIDTH-1]) & seg_result[i][STG_WIDTH-1]);
            end
        end
    end
end

// Output registers
reg [DATA_WIDTH:0] out_result;
reg o_en_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        out_result <= {DATA_WIDTH+1{1'b0}};
        o_en_reg <= 1'b0;
    end else if (en_pipe[(DATA_WIDTH/STG_WIDTH)-1]) begin
        out_result <= {carry[(DATA_WIDTH/STG_WIDTH)-1], seg_result[(DATA_WIDTH/STG_WIDTH)-1][STG_WIDTH-1:0]};
        for (int i = (DATA_WIDTH/STG_WIDTH)-2; i >= 0; i--) begin
            out_result <= {seg_result[i][STG_WIDTH-1:0], out_result[DATA_WIDTH:STG_WIDTH]};
        end
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

assign result = out_result;
assign o_en = o_en_reg;

endmodule