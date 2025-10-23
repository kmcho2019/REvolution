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
reg [2*size-1:0] accumulated_sum;
reg [2*size-1:0] next_partial_product;
reg [2*size-1:0] next_accumulated_sum;

reg [size-1:0] counter;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        partial_product <= {2*size{1'b0}};
        accumulated_sum <= {2*size{1'b0}};
        counter <= {size{1'b0}};
    end else begin
        // Partial product generation stage
        if (counter == {size{1'b0}}) begin
            next_partial_product <= {size{1'b0}, mul_a};
        end else if (mul_b[counter[size-1]]) begin
            next_partial_product <= {1'b0, partial_product[2*size-1:1]} + {size{1'b0}, mul_a};
        end else begin
            next_partial_product <= {1'b0, partial_product[2*size-1:1]};
        end

        // Accumulation stage
        next_accumulated_sum <= accumulated_sum + next_partial_product;

        // Update registers
        partial_product <= next_partial_product;
        accumulated_sum <= next_accumulated_sum;

        // Update counter
        if (counter == {size{1'b1}}) begin
            counter <= {size{1'b0}};
        end else begin
            counter <= counter + 1'b1;
        end
    end
end

always @(posedge clk) begin
    if (counter == {size{1'b0}}) begin
        mul_out <= accumulated_sum;
    end
end

endmodule