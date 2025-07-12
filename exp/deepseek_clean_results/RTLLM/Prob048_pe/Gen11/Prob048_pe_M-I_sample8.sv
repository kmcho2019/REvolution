module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Registered inputs for better timing
    reg signed [31:0] a_reg, b_reg;
    reg signed [31:0] a_prev, b_prev;
    wire inputs_changed;

    // Full precision accumulation
    reg signed [63:0] acc;

    // Pipelined multiplication signals
    reg signed [63:0] stage1_product;
    wire signed [63:0] final_product;

    // Booth multiplication (2-stage pipelined)
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'b0;
            b_reg <= 32'b0;
            a_prev <= 32'b0;
            b_prev <= 32'b0;
            stage1_product <= 64'b0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            a_prev <= a_reg;
            b_prev <= b_reg;
            
            // Stage 1: Partial product generation
            stage1_product <= a_reg * b_reg;
        end
    end

    // Stage 2: Final product (combinational)
    assign final_product = stage1_product;

    // Input change detection
    assign inputs_changed = (a_reg != a_prev) || (b_reg != b_prev);

    // Accumulation logic
    always @(posedge clk) begin
        if (rst) begin
            acc <= 64'b0;
            c <= 32'b0;
        end else begin
            if (inputs_changed) begin
                acc <= acc + final_product;
            end
            // Final truncation to 32 bits
            c <= acc[31:0];
        end
    end

endmodule