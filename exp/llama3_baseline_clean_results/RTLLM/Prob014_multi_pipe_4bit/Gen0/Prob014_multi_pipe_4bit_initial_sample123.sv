module multi_pipe_4bit #(
    parameter size = 4
)(
    input  clk,
    input  rst_n,
    input  [size-1:0] mul_a,
    input  [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;

// Extension of input signals
reg [2*size-1:0] ext_a;
reg [2*size-1:0] ext_b;

assign ext_a = {size'd0, mul_a};
assign ext_b = {size'd0, mul_b};

// First level of registers to store partial products
genvar i;
generate
    for (i = 0; i < size; i++) begin
        reg [2*size-1:0] partial_product;
        
        always @(posedge clk or negedge rst_n) begin
            if (~rst_n) begin
                partial_product <= 'd0;
            end else if (ext_b[i] == 1'b1) begin
                partial_product <= ext_a << i;
            end else begin
                partial_product <= 'd0;
            end
        end
        
        // Add partial products
        if (i == 0) begin
            assign reg1 = partial_product;
        end else begin
            reg [2*size-1:0] sum;
            always @(posedge clk or negedge rst_n) begin
                if (~rst_n) begin
                    sum <= 'd0;
                end else begin
                    sum <= reg1 + partial_product;
                end
            end
            assign reg1 = sum;
        end
    end
endgenerate

// Second level of registers to store intermediate sum
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg2 <= 'd0;
    end else begin
        reg2 <= reg1;
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 'd0;
    end else begin
        mul_out <= reg2;
    end
end

endmodule