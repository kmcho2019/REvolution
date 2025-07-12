module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= {2*size{1'b0}};
        reg2 <= {2*size{1'b0}};
    end else begin
        reg1 <= {size{1'b0}} + mul_a;
        reg2 <= {2*size{1'b0}};
        for (int i = 0; i < size; i++) begin
            if (mul_b[i] == 1'b1) begin
                reg2 <= reg2 + (mul_a << i);
            end
        end
    end
end

always @(posedge clk) begin
    if (rst_n) begin
        mul_out <= reg2;
    end else begin
        mul_out <= {2*size{1'b0}};
    end
end

endmodule