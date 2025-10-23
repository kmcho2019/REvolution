module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output wire signed [31:0] c
);

    // Registered inputs
    reg signed [31:0] a_reg, b_reg;
    wire signed [63:0] product;
    reg signed [63:0] acc;
    
    // Clock gating control
    wire inputs_zero = (a == 0) && (b == 0);
    wire clk_en = ~inputs_zero && ~rst;
    
    // Booth encoded multiplier (2-stage pipelined)
    reg signed [31:0] a_stage1, b_stage1;
    reg signed [63:0] partial_prod;
    
    // Stage 1: Partial products generation
    always @(posedge clk) begin
        if (rst) begin
            a_stage1 <= 0;
            b_stage1 <= 0;
        end else if (clk_en) begin
            a_stage1 <= a_reg;
            b_stage1 <= b_reg;
        end
    end
    
    // Stage 2: Final addition
    always @(posedge clk) begin
        if (rst) begin
            partial_prod <= 0;
        end else if (clk_en) begin
            partial_prod <= a_stage1 * b_stage1;
        end
    end
    
    // Input registers
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 0;
            b_reg <= 0;
        end else begin
            a_reg <= a;
            b_reg <= b;
        end
    end
    
    // Accumulator
    always @(posedge clk) begin
        if (rst) begin
            acc <= 0;
        end else if (clk_en) begin
            acc <= acc + partial_prod;
        end
    end
    
    // Output truncation
    assign c = acc[31:0];

endmodule