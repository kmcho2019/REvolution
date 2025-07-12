module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] pipe_a [3:0];
reg [63:0] pipe_b [3:0];
reg [0:0] pipe_cin [3:0];
reg [0:0] pipe_cout [3:0];
reg [63:0] pipe_sum [3:0];
reg i_en_sync [3:0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pipe_a[0] <= 64'd0;
        pipe_b[0] <= 64'd0;
        pipe_cin[0] <= 1'd0;
        i_en_sync[0] <= 1'd0;
    end else if (i_en) begin
        pipe_a[0] <= adda;
        pipe_b[0] <= addb;
        pipe_cin[0] <= 1'd0;
        i_en_sync[0] <= 1'd1;
    end else begin
        pipe_a[0] <= pipe_a[0];
        pipe_b[0] <= pipe_b[0];
        pipe_cin[0] <= pipe_cin[0];
        i_en_sync[0] <= i_en_sync[0];
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pipe_cout[0] <= 1'd0;
        pipe_sum[0] <= 64'd0;
    end else begin
        pipe_sum[0] <= pipe_a[0] + pipe_b[0] + pipe_cin[0];
        pipe_cout[0] <= (pipe_a[0][0] & pipe_b[0][0]) | (pipe_a[0][0] & pipe_cin[0][0]) | (pipe_b[0][0] & pipe_cin[0][0]);
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pipe_a[1] <= 64'd0;
        pipe_b[1] <= 64'd0;
        pipe_cin[1] <= 1'd0;
        i_en_sync[1] <= 1'd0;
    end else if (i_en_sync[0]) begin
        pipe_a[1] <= pipe_a[0];
        pipe_b[1] <= pipe_b[0];
        pipe_cin[1] <= pipe_cout[0];
        i_en_sync[1] <= i_en_sync[0];
    end else begin
        pipe_a[1] <= pipe_a[1];
        pipe_b[1] <= pipe_b[1];
        pipe_cin[1] <= pipe_cin[1];
        i_en_sync[1] <= i_en_sync[1];
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pipe_cout[1] <= 1'd0;
        pipe_sum[1] <= 64'd0;
    end else begin
        pipe_sum[1] <= pipe_a[1] + pipe_b[1] + {63'd0, pipe_cin[1]};
        pipe_cout[1] <= (pipe_a[1][1] & pipe_b[1][1]) | (pipe_a[1][1] & pipe_cin[1]) | (pipe_b[1][1] & pipe_cin[1]);
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pipe_a[2] <= 64'd0;
        pipe_b[2] <= 64'd0;
        pipe_cin[2] <= 1'd0;
        i_en_sync[2] <= 1'd0;
    end else if (i_en_sync[1]) begin
        pipe_a[2] <= pipe_a[1];
        pipe_b[2] <= pipe_b[1];
        pipe_cin[2] <= pipe_cout[1];
        i_en_sync[2] <= i_en_sync[1];
    end else begin
        pipe_a[2] <= pipe_a[2];
        pipe_b[2] <= pipe_b[2];
        pipe_cin[2] <= pipe_cin[2];
        i_en_sync[2] <= i_en_sync[2];
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pipe_cout[2] <= 1'd0;
        pipe_sum[2] <= 64'd0;
    end else begin
        pipe_sum[2] <= pipe_a[2] + pipe_b[2] + {62'd0, pipe_cin[2], 1'd0};
        pipe_cout[2] <= (pipe_a[2][2] & pipe_b[2][2]) | (pipe_a[2][2] & pipe_cin[2]) | (pipe_b[2][2] & pipe_cin[2]);
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pipe_a[3] <= 64'd0;
        pipe_b[3] <= 64'd0;
        pipe_cin[3] <= 1'd0;
        i_en_sync[3] <= 1'd0;
    end else if (i_en_sync[2]) begin
        pipe_a[3] <= pipe_a[2];
        pipe_b[3] <= pipe_b[2];
        pipe_cin[3] <= pipe_cout[2];
        i_en_sync[3] <= i_en_sync[2];
    end else begin
        pipe_a[3] <= pipe_a[3];
        pipe_b[3] <= pipe_b[3];
        pipe_cin[3] <= pipe_cin[3];
        i_en_sync[3] <= i_en_sync[3];
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'd0;
        o_en <= 1'd0;
    end else if (i_en_sync[3]) begin
        result <= {pipe_cout[3], pipe_sum[3]};
        o_en <= 1'd1;
    end else begin
        result <= result;
        o_en <= 1'd0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pipe_cout[3] <= 1'd0;
        pipe_sum[3] <= 64'd0;
    end else begin
        pipe_sum[3] <= pipe_a[3] + pipe_b[3] + {60'd0, pipe_cin[3], 3'd0};
        pipe_cout[3] <= (pipe_a[3][3] & pipe_b[3][3]) | (pipe_a[3][3] & pipe_cin[3]) | (pipe_b[3][3] & pipe_cin[3]);
    end
end

endmodule