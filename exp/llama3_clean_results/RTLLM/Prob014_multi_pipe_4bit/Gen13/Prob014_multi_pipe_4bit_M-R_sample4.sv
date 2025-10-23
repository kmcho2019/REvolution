module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] partial_product_reg [size-1:0];
reg [2*size-1:0] accumulated_sum_reg;
reg [2*size-1:0] temp;
reg [1:0] counter;

// Counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 2'b00;
    end else begin
        case (counter)
            2'b00: begin
                counter <= 2'b01;
            end
            2'b01: begin
                counter <= 2'b10;
            end
            2'b10: begin
                counter <= 2'b00;
            end
            default: begin
                counter <= 2'b00;
            end
        endcase
    end
end

// Reset logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accumulated_sum_reg <= {2*size{1'b0}};
        mul_out <= {2*size{1'b0}};
    end
end

// Partial product generation stage
genvar i;
generate
    for (i = 0; i < size; i++) begin
        assign partial_product_reg[i] = (mul_b[i] == 1'b1)? ({mul_a, {size{1'b0}}} << i) : {2*size{1'b0}};
    end
endgenerate

// Accumulation stage
always @(posedge clk) begin
    if (counter == 2'b10) begin
        accumulated_sum_reg <= {2*size{1'b0}};
        for (int i = 0; i < size; i++) begin
            accumulated_sum_reg <= accumulated_sum_reg + partial_product_reg[i];
        end
        mul_out <= accumulated_sum_reg;
    end
end

endmodule