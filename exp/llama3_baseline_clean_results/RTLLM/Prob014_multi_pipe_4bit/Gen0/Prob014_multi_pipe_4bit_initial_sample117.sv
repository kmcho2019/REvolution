module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

// Intermediate registers
reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;

// Extended input signals
wire [2*size-1:0] ext_mul_a;
wire [2*size-1:0] ext_mul_b;

// Assign extended input signals
assign ext_mul_a = { {size{1'b0}}, mul_a };
assign ext_mul_b = { {size{1'b0}}, mul_b };

// Generate partial products
genvar i;
generate
    for (i = 0; i < size; i++) begin
        wire [2*size-1:0] partial_product;
        assign partial_product = (ext_mul_b[i]) ? (ext_mul_a << i) : { {2*size{1'b0}} };
        if (i == 0) begin
            assign reg1 = partial_product;
        end else begin
            reg [2*size-1:0] temp;
            always @ (posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    temp <= { {2*size{1'b0}} };
                end else begin
                    temp <= reg1 + partial_product;
                end
            end
            assign reg1 = temp;
        end
    end
endgenerate

// Update final product
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg2 <= { {2*size{1'b0}} };
    end else begin
        reg2 <= reg1;
    end
end

assign mul_out = reg2;

endmodule