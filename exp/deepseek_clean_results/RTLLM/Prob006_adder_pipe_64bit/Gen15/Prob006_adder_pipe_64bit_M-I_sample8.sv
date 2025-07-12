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
reg [15:0] a1, b1, a2, b2, a3, b3, a4, b4;
reg [16:0] sum1, sum2, sum3, sum4;
reg [3:0] en_pipe;

// Stage 1: Bits 0-15
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a1 <= 0;
        b1 <= 0;
        sum1 <= 0;
        en_pipe[0] <= 0;
    end else begin
        a1 <= adda[15:0];
        b1 <= addb[15:0];
        sum1 <= {1'b0, a1} + {1'b0, b1}; // No carry-in for first stage
        en_pipe[0] <= i_en;
    end
end

// Stage 2: Bits 16-31
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a2 <= 0;
        b2 <= 0;
        sum2 <= 0;
        en_pipe[1] <= 0;
    end else begin
        a2 <= adda[31:16];
        b2 <= addb[31:16];
        sum2 <= {1'b0, a2} + {1'b0, b2} + sum1[16]; // Carry from stage 1
        en_pipe[1] <= en_pipe[0];
    end
end

// Stage 3: Bits 32-47
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a3 <= 0;
        b3 <= 0;
        sum3 <= 0;
        en_pipe[2] <= 0;
    end else begin
        a3 <= adda[47:32];
        b3 <= addb[47:32];
        sum3 <= {1'b0, a3} + {1'b0, b3} + sum2[16]; // Carry from stage 2
        en_pipe[2] <= en_pipe[1];
    end
end

// Stage 4: Bits 48-63
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a4 <= 0;
        b4 <= 0;
        sum4 <= 0;
        en_pipe[3] <= 0;
    end else begin
        a4 <= adda[63:48];
        b4 <= addb[63:48];
        sum4 <= {1'b0, a4} + {1'b0, b4} + sum3[16]; // Carry from stage 3
        en_pipe[3] <= en_pipe[2];
    end
end

// Output stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 0;
        o_en <= 0;
    end else begin
        result <= {sum4[16:0], sum3[15:0], sum2[15:0], sum1[15:0]};
        o_en <= en_pipe[3];
    end
end

endmodule