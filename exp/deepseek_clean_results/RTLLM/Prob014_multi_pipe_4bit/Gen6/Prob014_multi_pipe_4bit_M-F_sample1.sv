module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Stage 1: Partial product generation
reg [2*size-1:0] pp0, pp1, pp2, pp3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pp0 <= {2*size{1'b0}};
        pp1 <= {2*size{1'b0}};
        pp2 <= {2*size{1'b0}};
        pp3 <= {2*size{1'b0}};
    end else begin
        pp0 <= mul_b[0] ? {{size{1'b0}}, mul_a}       : {2*size{1'b0}};
        pp1 <= mul_b[1] ? {{size-1{1'b0}}, mul_a, 1'b0} : {2*size{1'b0}};
        pp2 <= mul_b[2] ? {{size-2{1'b0}}, mul_a, 2'b0} : {2*size{1'b0}};
        pp3 <= mul_b[3] ? {{size-3{1'b0}}, mul_a, 3'b0} : {2*size{1'b0}};
    end
end

// Stage 2: Final sum
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= {2*size{1'b0}};
    end else begin
        mul_out <= pp0 + pp1 + pp2 + pp3;
    end
end

endmodule