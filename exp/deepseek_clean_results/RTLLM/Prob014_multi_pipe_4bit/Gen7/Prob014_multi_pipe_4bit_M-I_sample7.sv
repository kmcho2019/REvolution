module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Booth encoder outputs
    reg [1:0] booth_sel [0:1];
    reg [size:0] booth_pp [0:1];  // size+1 bits for sign extension
    
    // Generate Booth encoding signals
    always @(*) begin
        // First Booth encoding (bits 1:0 with implied -1)
        booth_sel[0] = {mul_b[0], 1'b0};
        case (booth_sel[0])
            2'b01: booth_pp[0] = {mul_a[size-1], mul_a};  // +1*multiplicand
            2'b10: booth_pp[0] = ~{mul_a[size-1], mul_a} + 1'b1; // -1*multiplicand
            default: booth_pp[0] = {(size+1){1'b0}};      // 0
        endcase

        // Second Booth encoding (bits 3:1)
        booth_sel[1] = mul_b[2:1];
        case (booth_sel[1])
            2'b01: booth_pp[1] = {mul_a[size-1], mul_a};  // +1*multiplicand
            2'b10: booth_pp[1] = ~{mul_a[size-1], mul_a} + 1'b1; // -1*multiplicand
            default: booth_pp[1] = {(size+1){1'b0}};      // 0
        endcase
    end

    // Pipeline Stage 1: Register Booth outputs
    reg [size:0] pp0_reg, pp1_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp0_reg <= {(size+1){1'b0}};
            pp1_reg <= {(size+1){1'b0}};
        end else begin
            pp0_reg <= booth_pp[0];
            pp1_reg <= booth_pp[1];
        end
    end

    // Pipeline Stage 2: Shift and add partial products
    // pp0 needs no shift, pp1 needs 2-bit shift (radix-4)
    wire [2*size-1:0] pp0_ext = {{(size-1){pp0_reg[size]}}, pp0_reg};
    wire [2*size-1:0] pp1_ext = {{(size-3){pp1_reg[size]}}, pp1_reg, 2'b0};
    
    reg [2*size-1:0] sum_stage2;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2 <= {(2*size){1'b0}};
        end else begin
            sum_stage2 <= pp0_ext + pp1_ext;
        end
    end

    // Pipeline Stage 3: Final output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {(2*size){1'b0}};
        end else begin
            mul_out <= sum_stage2;
        end
    end

endmodule