module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // Internal registers
    reg [15:0] a_reg, b_reg;
    reg [31:0] product;
    reg calc_done;
    reg zero_case;

    // Partial product wires
    wire [31:0] partial_products [15:0];
    wire [31:0] sum_stage1 [7:0];
    wire [31:0] sum_stage2 [3:0];
    wire [31:0] sum_stage3 [1:0];
    wire [31:0] final_sum;

    // Generate all partial products in parallel
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : pp_gen
            assign partial_products[i] = bin[i] ? (ain << i) : 32'd0;
        end
    endgenerate

    // First stage of adder tree (16 -> 8)
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1
            assign sum_stage1[i] = partial_products[2*i] + partial_products[2*i+1];
        end
    endgenerate

    // Second stage of adder tree (8 -> 4)
    generate
        for (i = 0; i < 4; i = i + 1) begin : stage2
            assign sum_stage2[i] = sum_stage1[2*i] + sum_stage1[2*i+1];
        end
    endgenerate

    // Third stage of adder tree (4 -> 2)
    generate
        for (i = 0; i < 2; i = i + 1) begin : stage3
            assign sum_stage3[i] = sum_stage2[2*i] + sum_stage2[2*i+1];
        end
    endgenerate

    // Final addition
    assign final_sum = sum_stage3[0] + sum_stage3[1];

    // Zero case detection
    always @(*) begin
        zero_case = (ain == 16'd0) || (bin == 16'd0);
    end

    // Control FSM
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 16'd0;
            b_reg <= 16'd0;
            product <= 32'd0;
            calc_done <= 1'b0;
            done <= 1'b0;
            yout <= 32'd0;
        end else begin
            if (start) begin
                a_reg <= ain;
                b_reg <= bin;
                calc_done <= 1'b1;
                
                if (zero_case) begin
                    product <= 32'd0;
                    done <= 1'b1;
                end else begin
                    product <= final_sum;
                    done <= 1'b1;
                end
            end else begin
                calc_done <= 1'b0;
                done <= 1'b0;
            end

            // Pipeline output for better timing
            if (calc_done) begin
                yout <= product;
            end
        end
    end

endmodule