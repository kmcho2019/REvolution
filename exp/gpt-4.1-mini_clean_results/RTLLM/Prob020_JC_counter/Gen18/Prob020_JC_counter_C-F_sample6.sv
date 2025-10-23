module JC_counter (
    input  wire       clk,
    input  wire       rst_n,
    output reg [63:0] Q
);

integer i;
reg feedback_bit;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        // Compute the feedback bit as inverse of LSB before shifting
        feedback_bit = ~Q[0];
        // Shift bits right by one position using non-blocking assignments
        for (i = 0; i < 63; i = i + 1) begin
            Q[i] <= Q[i+1];
        end
        // Assign feedback bit to MSB
        Q[63] <= feedback_bit;
    end
end

endmodule