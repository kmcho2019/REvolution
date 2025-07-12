module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire tap3_feedback;
wire tap5_feedback;

assign tap3_feedback = q[0] ^ q[2];  // Position 3 (index 2)
assign tap5_feedback = q[0] ^ q[4];  // Position 5 (index 4)

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        q <= {tap5_feedback, q[3], tap3_feedback, q[1], q[0]};
    end
end

endmodule