module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback;
wire [4:0] next_q;

assign feedback = q[0];

// Calculate next state of the LFSR based on feedback and taps at bits 5 (q[4]) and 3 (q[2])
assign next_q[0] = q[1];
assign next_q[1] = q[2];
assign next_q[2] = q[3] ^ feedback;
assign next_q[3] = q[4];
assign next_q[4] = feedback;

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;  // Reset to 1 on active-high synchronous reset
    end else begin
        q <= next_q;
    end
end

endmodule