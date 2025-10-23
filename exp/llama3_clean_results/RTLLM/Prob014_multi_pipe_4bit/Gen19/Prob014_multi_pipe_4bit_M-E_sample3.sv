module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] partial_product;
reg [2*size-1:0] shifted_a;
reg [2*size-1:0] add_result;
reg [2*size-1:0] pipe_reg1;
reg [2*size-1:0] pipe_reg2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        partial_product <= {2*size{1'b0}};
        shifted_a <= {2*size{1'b0}};
        add_result <= {2*size{1'b0}};
        pipe_reg1 <= {2*size{1'b0}};
        pipe_reg2 <= {2*size{1'b0}};
    end else begin
        // Input stage
        partial_product <= {2*size{1'b0}};
        shifted_a <= {size{1'b0}} | mul_a;

        // Shift and add stage
        for (int i = 0; i < size; i++) begin
            if (mul_b[i] == 1'b1) begin
                partial_product <= partial_product + (shifted_a << i);
            end
        end

        // Pipelining stage
        pipe_reg1 <= partial_product;
        pipe_reg2 <= pipe_reg1;
    end
end

always @(posedge clk) begin
    if (rst_n) begin
        mul_out <= pipe_reg2;
    end else begin
        mul_out <= {2*size{1'b0}};
    end
end

endmodule