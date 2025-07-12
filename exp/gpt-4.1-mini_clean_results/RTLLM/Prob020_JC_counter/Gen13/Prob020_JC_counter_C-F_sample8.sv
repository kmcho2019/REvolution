module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        // Johnson counter next state:
        // Q shifts right by one bit.
        // MSB of Q gets inverse of current LSB (Q[0]).
        // This creates the characteristic torsional ring counting sequence.
        Q <= {~Q[0], Q[63:1]};
    end
end

endmodule