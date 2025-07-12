module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

wire feedback = q[0] ^ q[4] ^ q[2];
wire [4:0] next_q = {feedback, q[4:1]};

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        q <= next_q;
    end
end

endmodule