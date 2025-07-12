module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        // Shift right by 1 bit
        for (i = 0; i < 63; i = i + 1) begin
            Q[i] <= Q[i+1];
        end
        // MSB is inverse of LSB
        Q[63] <= ~Q[0];
    end
end

endmodule