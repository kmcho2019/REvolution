module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Next state calculation (combinational logic)
wire [63:0] next_Q;
assign next_Q = !rst_n ? 64'b0 :          // Reset condition
                Q[0] ? {1'b0, Q[63:1]} :  // Count down when LSB=1
                {1'b1, Q[63:1]};         // Count up when LSB=0

// State register (sequential logic)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        Q <= next_Q;
    end
end

endmodule