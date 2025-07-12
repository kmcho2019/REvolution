module multi_pipe_4bit #(parameter size=4) (
    input                      clk,
    input                      rst_n,
    input      [size-1:0]      mul_a,
    input      [size-1:0]      mul_b,
    output reg [2*size-1:0]    mul_out
);

    // -----------------------------------------------------
    // Stage 0: Register inputs with zero extension
    // -----------------------------------------------------
    reg [2*size-1:0] reg_mul_a;
    reg [size-1:0]    reg_mul_b;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_mul_a <= {2*size{1'b0}};
            reg_mul_b <= {size{1'b0}};
        end else begin
            reg_mul_a <= {{size{1'b0}}, mul_a}; // extend mul_a at MSBs by size zeros
            reg_mul_b <= mul_b;                  // mul_b is registered as is
        end
    end

    // -----------------------------------------------------
    // Stage 1: Generate partial products combinationally from registered inputs
    // -----------------------------------------------------
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = reg_mul_b[i] ? (reg_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // -----------------------------------------------------
    // Stage 2: Register partial products
    // -----------------------------------------------------
    reg [2*size-1:0] reg_partial_products [0:size-1];
    integer idx;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx=0; idx<size; idx=idx+1)
                reg_partial_products[idx] <= {2*size{1'b0}};
        end else begin
            for (idx=0; idx<size; idx=idx+1)
                reg_partial_products[idx] <= partial_products[idx];
        end
    end

    // -----------------------------------------------------
    // Stage 3: Register sum of partial products
    // -----------------------------------------------------
    reg [2*size-1:0] reg_sum;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_sum <= {2*size{1'b0}};
        end else begin
            reg_sum <= reg_partial_products[0] + reg_partial_products[1] + reg_partial_products[2] + reg_partial_products[3];
        end
    end

    // -----------------------------------------------------
    // Stage 4: Final product register output
    // -----------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {2*size{1'b0}};
        end else begin
            mul_out <= reg_sum;
        end
    end

endmodule