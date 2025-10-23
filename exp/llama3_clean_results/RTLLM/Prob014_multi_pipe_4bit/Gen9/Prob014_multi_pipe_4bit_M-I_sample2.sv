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
reg [2*size-1:0] reg1; // first level of register
reg [2*size-1:0] reg2; // second level of register

// calculate partial products
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < size; i++) begin
            pp[i] <= {2*size{1'b0}};
        end
        reg1 <= {2*size{1'b0}};
        reg2 <= {2*size{1'b0}};
    end else begin
        for (int i = 0; i < size; i++) begin
            if (mul_b[i] == 1'b1) begin
                pp[i] <= (mul_a << i);
            end else begin
                pp[i] <= {2*size{1'b0}};
            end
        end
        reg1 <= pp[0] + pp[1];
        reg2 <= reg1 + pp[2] + pp[3];
    end
end

// output stage
always @(posedge clk) begin
    if (~rst_n) begin
        mul_out <= {2*size{1'b0}};
    end else begin
        mul_out <= reg2;
    end
end

endmodule