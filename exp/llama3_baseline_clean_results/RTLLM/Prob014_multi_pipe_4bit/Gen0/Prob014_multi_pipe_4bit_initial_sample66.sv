module multi_pipe_4bit #(
    parameter size = 4
)
(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;
wire [2*size-1:0] partial_product [size-1:0];

// Extend input signals by adding "size" number of zero bits at the most significant bit positions
wire [2*size-1:0] mul_a_ext = { {size{1'b0}}, mul_a };
wire [2*size-1:0] mul_b_ext = { {size{1'b0}}, mul_b };

// Generate block to perform multiplication for each bit position of the multiplier
genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin
        assign partial_product[i] = (mul_b_ext[i] == 1'b1) ? (mul_a_ext << i) : {2*size{1'b0}};
    end
endgenerate

// Store the intermediate sum values in registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg1 <= {2*size{1'b0}};
        reg2 <= {2*size{1'b0}};
    end else begin
        reg1 <= partial_product[0] + { {size{1'b0}}, mul_a } + {2*size{1'b0}};
        reg2 <= reg1 + partial_product[1] + { {size-1{1'b0}}, mul_a, 1'b0 };
    end
end

// Calculate the final product
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= {2*size{1'b0}};
    end else begin
        mul_out <= reg2 + partial_product[2] + { {size-2{1'b0}}, mul_a, 2'b00 };
        if (mul_b[3]) begin
            mul_out <= mul_out + { {size-3{1'b0}}, mul_a, 3'b000 };
        end
    end
end

endmodule