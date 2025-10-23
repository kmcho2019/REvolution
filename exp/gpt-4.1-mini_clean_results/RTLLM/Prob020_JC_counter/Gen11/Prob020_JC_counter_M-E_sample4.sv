module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

integer i;
reg feedback_bit;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'd0;
    end else begin
        feedback_bit = ~Q[0];
        // Shift bits right by one, insert feedback_bit at MSB
        for (i = 63; i > 0; i = i -1) begin
            Q[i] <= Q[i-1];
        end
        Q[0] <= feedback_bit;
    end
end

endmodule