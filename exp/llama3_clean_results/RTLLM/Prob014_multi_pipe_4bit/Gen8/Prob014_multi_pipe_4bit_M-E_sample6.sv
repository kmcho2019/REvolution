module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] pp [size-1:0]; // partial products
reg [2*size-1:0] reg1 [size-1:0]; // first level of registers
reg [2*size-1:0] reg2; // second level of register
reg [2*size-1:0] sum; // sum of partial products

// calculate partial products
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < size; i++) begin
            pp[i] <= {2*size{1'b0}};
        end
    end else begin
        for (int i = 0; i < size; i++) begin
            if (mul_b[i] == 1'b1) begin
                pp[i] <= {size{1'b0}, mul_a} << i;
            end else begin
                pp[i] <= {2*size{1'b0}};
            end
        end
    end
end

// first level of registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < size; i++) begin
            reg1[i] <= {2*size{1'b0}};
        end
    end else begin
        reg1[0] <= pp[0];
        reg1[1] <= pp[1];
        reg1[2] <= pp[2];
        reg1[3] <= pp[3];
    end
end

// second level of register
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg2 <= {2*size{1'b0}};
    end else begin
        sum <= {2*size{1'b0}};
        sum <= reg1[0] + reg1[1];
        sum <= sum + reg1[2];
        sum <= sum + reg1[3];
        reg2 <= sum;
    end
end

// output stage
always @(posedge clk) begin
    mul_out <= reg2;
end

endmodule