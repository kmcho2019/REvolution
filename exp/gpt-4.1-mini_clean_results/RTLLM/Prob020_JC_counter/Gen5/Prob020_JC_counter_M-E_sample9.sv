module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

always @(posedge clk) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        Q <= {~Q[0], Q[63:1]};
    end
end

endmodule