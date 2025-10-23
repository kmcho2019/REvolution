module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg next_bit;
reg [63:0] Q_shifted;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        next_bit <= 1'b0;
        Q_shifted <= 64'b0;
    end else begin
        // Stage 1: Compute next MSB
        next_bit <= ~Q[0];
        
        // Stage 2: Perform the shift with registered next_bit
        Q_shifted <= {next_bit, Q[63:1]};
        Q <= Q_shifted;
    end
end

endmodule