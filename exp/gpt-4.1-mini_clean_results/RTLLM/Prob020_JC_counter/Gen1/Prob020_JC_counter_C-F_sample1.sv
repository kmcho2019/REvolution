module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        // Shift right by 1, insert MSB = ~Q[0]
        Q <= {~Q[0], Q[63:1]};
    end
end

endmodule