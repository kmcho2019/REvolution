module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Continuous assignment for the feedback path
wire feedback = ~Q[0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;  // Active-low reset
    end else begin
        // Johnson counter operation:
        // Shift right and insert inverted LSB at MSB
        Q <= {feedback, Q[63:1]};
    end
end

endmodule