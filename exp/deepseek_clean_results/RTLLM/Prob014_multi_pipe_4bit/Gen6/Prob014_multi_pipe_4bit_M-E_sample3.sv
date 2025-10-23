module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Booth encoder outputs
    wire [1:0] booth_sel [0:size/2];
    wire [size:0] booth_pp [0:size/2];
    
    // Generate Booth encoding signals
    genvar i;
    generate
        for (i = 0; i <= size/2; i = i + 1) begin : booth_enc
            // Pad with zero for boundary conditions
            wire b_prev = (i == 0) ? 1'b0 : mul_b[2*i-1];
            wire b_curr = (2*i < size) ? mul_b[2*i] : 1'b0;
            wire b_next = (2*i+1 < size) ? mul_b[2*i+1] : 1'b0;
            
            // Booth encoding
            assign booth_sel[i] = {b_curr, b_prev};
            
            // Partial product generation
            always @(*) begin
                case (booth_sel[i])
                    2'b01: booth_pp[i] = {mul_a[size-1], mul_a};  // +1*multiplicand
                    2'b10: booth_pp[i] = ~{mul_a[size-1], mul_a} + 1'b1; // -1*multiplicand
                    default: booth_pp[i] = {(size+1){1'b0}};       // 0
                endcase
            end
        end
    endgenerate

    // Pipeline Stage 1: Register Booth outputs
    reg [size:0] pp0_reg, pp1_reg;
    reg [1:0] shift0_reg, shift1_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp0_reg <= {(size+1){1'b0}};
            pp1_reg <= {(size+1){1'b0}};
            shift0_reg <= 2'b0;
            shift1_reg <= 2'b0;
        end else begin
            pp0_reg <= booth_pp[0];
            pp1_reg <= booth_pp[1];
            shift0_reg <= 0;  // No shift for first PP
            shift1_reg <= 2;   // Shift second PP by 2 (radix-4)
        end
    end

    // Pipeline Stage 2: Shift and compress partial products
    wire [2*size-1:0] shifted_pp0 = {{(size-1){pp0_reg[size]}}, pp0_reg} << shift0_reg;
    wire [2*size-1:0] shifted_pp1 = {{(size-1){pp1_reg[size]}}, pp1_reg} << shift1_reg;
    
    reg [2*size-1:0] sum_stage2;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2 <= {(2*size){1'b0}};
        end else begin
            sum_stage2 <= shifted_pp0 + shifted_pp1;
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