module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

reg enable;
wire feedback = q[0];
wire [4:0] next_q = {feedback, q[4], q[3] ^ feedback, q[2], q[1]};

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
        enable <= 1'b1;
    end
    else begin
        enable <= |next_q; // Enable only if next state isn't zero
        if (enable) begin
            q <= next_q;
        end
    end
end

endmodule