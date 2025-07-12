module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

// extend input signals by adding size number of zero bits at the most significant bit positions
wire [2*size-1:0] extended_mul_a = {size'd0, mul_a};
wire [2*size-1:0] extended_mul_b = {size'd0, mul_b};

// first level of registers to store intermediate values
reg [2*size-1:0] reg1 [size-1:0];
reg [2*size-1:0] reg2;

// initialization of reg1
integer i;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < size; i++) begin
            reg1[i] <= 0;
        end
    end else begin
        for (i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                reg1[i] <= extended_mul_a << i;
            end else begin
                reg1[i] <= 0;
            end
        end
    end
end

// second level of registers to store intermediate values
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg2 <= 0;
    end else begin
        reg2 <= reg1[0];
        for (i = 1; i < size; i++) begin
            reg2 <= reg2 + reg1[i];
        end
    end
end

// output product calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 0;
    end else begin
        mul_out <= reg2;
    end
end

endmodule