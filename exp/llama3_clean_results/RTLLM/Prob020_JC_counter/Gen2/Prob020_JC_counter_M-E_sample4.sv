module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [63:0] buffer;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        buffer <= 64'd0;
    end else begin
        if (buffer[0] == 1'b0) begin
            buffer <= {1'b1, buffer[63:1]};
        end else begin
            buffer <= {1'b0, buffer[63:1]};
        end
    end
    Q <= buffer;
end

endmodule