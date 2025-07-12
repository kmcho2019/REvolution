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
        // Temporary register to hold next state
        reg [63:0] next_Q;
        // MSB gets inverse of current LSB
        next_Q[63] = ~Q[0];
        // Shift bits right by one: each bit i gets Q[i+1]
        for (i = 62; i >= 0; i = i - 1) begin
            next_Q[i] = Q[i+1];
        end
        Q <= next_Q;
    end
end

endmodule