module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

// Bit-Parallel Booth Encoder (BPBE)
reg [1:0] booth_encoding;
always @(posedge clk) begin
    if(reset) booth_encoding <= 0;
    else booth_encoding <= {a[0], a[1]};
end

// Parallel Multiplicand Generator (PMG)
reg [15:0] multiplicand_add, multiplicand_sub;
always @(posedge clk) begin
    if(reset) begin
        multiplicand_add <= { {8{b[7]}}, b };
        multiplicand_sub <= -{ {8{b[7]}}, b };
    end else begin
        multiplicand_add <= multiplicand_add << 1;
        multiplicand_sub <= multiplicand_sub << 1;
    end
end

// Pipelined Adder Tree (PAT)
reg [15:0] product_stage1, product_stage2;
always @(posedge clk) begin
    if(reset) begin
        product_stage1 <= 0;
        product_stage2 <= 0;
    end else if(booth_encoding == 2'b10) begin // Add
        product_stage1 <= product_stage1 + multiplicand_add;
    end else if(booth_encoding == 2'b11) begin // Subtract
        product_stage1 <= product_stage1 - multiplicand_sub;
    end
    product_stage2 <= product_stage1;
end

// Control and Synchronization Unit (CSU)
reg [4:0] ctr;
always @(posedge clk) begin
    if(reset) begin
        ctr <= 0;
        rdy <= 0;
    end else if(ctr < 16) begin
        ctr <= ctr + 1;
    end else begin
        rdy <= 1;
    end
end

// Final Output Logic
always @(posedge clk) begin
    if(reset) p <= 0;
    else p <= product_stage2;
end

endmodule