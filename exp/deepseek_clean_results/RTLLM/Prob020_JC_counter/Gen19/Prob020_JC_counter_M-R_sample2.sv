module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Feedback path from LSB to MSB
wire next_bit = ~Q[0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        // Single shift operation with feedback
        Q <= {next_bit, Q[63:1]};
    end
end

endmodule