module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [31:0] partial_products [15:0];
reg [31:0] reduced_partial_products [7:0];
reg [31:0] final_product;
reg done_r;

// Parallel Multiplication Array
genvar i, j;
generate
    for (i = 0; i < 16; i++) begin
        for (j = 0; j < 16; j++) begin
            assign partial_products[i][j] = ain[i] & bin[j];
        end
    end
endgenerate

// Wallace Tree Reduction
wire [31:0] reduced_pp [7:0];
assign reduced_pp[0] = partial_products[0] + partial_products[1];
assign reduced_pp[1] = partial_products[2] + partial_products[3];
assign reduced_pp[2] = partial_products[4] + partial_products[5];
assign reduced_pp[3] = partial_products[6] + partial_products[7];
assign reduced_pp[4] = partial_products[8] + partial_products[9];
assign reduced_pp[5] = partial_products[10] + partial_products[11];
assign reduced_pp[6] = partial_products[12] + partial_products[13];
assign reduced_pp[7] = partial_products[14] + partial_products[15];

// Final Adder
assign final_product = reduced_pp[0] + reduced_pp[1] + reduced_pp[2] + reduced_pp[3] + reduced_pp[4] + reduced_pp[5] + reduced_pp[6] + reduced_pp[7];

// Control and Interface Logic
always @(posedge clk) begin
    if (!rst_n) begin
        done_r <= 1'b0;
        yout <= 32'd0;
    end else if (start) begin
        done_r <= 1'b1;
        yout <= final_product;
    end
end

assign done = done_r;

endmodule