module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;

// Initialize registers
initial begin
    reg1 = 0;
    reg2 = 0;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= 0;
        reg2 <= 0;
    end else begin
        reg1 <= 0;
        for (int i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                reg1 <= reg1 + (mul_a << i);
            end
        end
        reg2 <= reg1;
    end
end

assign mul_out = reg2;

endmodule