module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extension Stage
reg [2*size-1:0] extended_mul_a;
assign extended_mul_a = {size{1'b0}} | mul_a;

// Booth Encoder Stage
reg [size-1:0] booth_encoded_mul_b;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        booth_encoded_mul_b <= {size{1'b0}};
    end else begin
        reg [size-1:0] temp_booth_encoded;
        temp_booth_encoded = {size{1'b0}};
        for (int i = 0; i < size; i++) begin
            if (i == 0) begin
                if (mul_b[i] == 1'b1) begin
                    temp_booth_encoded[i] = 1'b1;
                end
            end else begin
                if (mul_b[i] == 1'b1 && mul_b[i-1] == 1'b0) begin
                    temp_booth_encoded[i] = 1'b1;
                end else if (mul_b[i] == 1'b0 && mul_b[i-1] == 1'b1) begin
                    temp_booth_encoded[i] = 1'b1;
                end
            end
        end
        booth_encoded_mul_b <= temp_booth_encoded;
    end
end

// Partial Product Generation Stage
reg [2*size-1:0] partial_product;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        partial_product <= {2*size{1'b0}};
    end else begin
        reg [2*size-1:0] temp_partial_product;
        temp_partial_product = {2*size{1'b0}};
        for (int i = 0; i < size; i++) begin
            if (booth_encoded_mul_b[i] == 1'b1) begin
                temp_partial_product = temp_partial_product + (extended_mul_a << i);
            end
        end
        partial_product <= temp_partial_product;
    end
end

// Summation Stage
reg [2*size-1:0] sum1;
reg [2*size-1:0] sum2;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum1 <= {2*size{1'b0}};
        sum2 <= {2*size{1'b0}};
    end else begin
        sum1 <= partial_product;
        sum2 <= sum1 + partial_product;
    end
end

// Output Stage
always @(posedge clk) begin
    mul_out <= sum2;
end

endmodule