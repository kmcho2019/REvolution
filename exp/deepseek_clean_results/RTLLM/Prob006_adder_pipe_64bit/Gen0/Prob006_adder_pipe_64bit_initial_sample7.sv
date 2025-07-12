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
reg [15:0] a0, a1, a2, a3;
reg [15:0] b0, b1, b2, b3;
reg [16:0] sum0, sum1, sum2;
reg [3:0] en_pipe;

// Pipeline stage 0: Split inputs into 16-bit chunks
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a0 <= 16'b0;
        b0 <= 16'b0;
        a1 <= 16'b0;
        b1 <= 16'b0;
        a2 <= 16'b0;
        b2 <= 16'b0;
        a3 <= 16'b0;
        b3 <= 16'b0;
        en_pipe <= 4'b0;
    end else begin
        if (i_en) begin
            a0 <= adda[15:0];
            b0 <= addb[15:0];
            a1 <= adda[31:16];
            b1 <= addb[31:16];
            a2 <= adda[47:32];
            b2 <= addb[47:32];
            a3 <= adda[63:48];
            b3 <= addb[63:48];
        end
        en_pipe <= {en_pipe[2:0], i_en};
    end
end

// Pipeline stage 1: Add first 16 bits
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum0 <= 17'b0;
    end else if (en_pipe[0]) begin
        sum0 <= {1'b0, a0} + {1'b0, b0};
    end
end

// Pipeline stage 2: Add next 16 bits with carry from stage 1
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum1 <= 17'b0;
    end else if (en_pipe[1]) begin
        sum1 <= {1'b0, a1} + {1'b0, b1} + sum0[16];
    end
end

// Pipeline stage 3: Add next 16 bits with carry from stage 2
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum2 <= 17'b0;
    end else if (en_pipe[2]) begin
        sum2 <= {1'b0, a2} + {1'b0, b2} + sum1[16];
    end
end

// Pipeline stage 4: Add final 16 bits with carry from stage 3 and assemble result
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else if (en_pipe[3]) begin
        result <= {1'b0, a3} + {1'b0, b3} + sum2[16];
        result[63:48] <= sum2[15:0];
        result[47:32] <= sum1[15:0];
        result[31:16] <= sum0[15:0];
        o_en <= 1'b1;
    end else begin
        o_en <= 1'b0;
    end
end

endmodule