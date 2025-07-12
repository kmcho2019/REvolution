module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

wire feedback = (q == 4'b0100);  // Terminal state detection

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else if (slowena) begin
        if (feedback) begin
            q <= 4'b0000;
        end
        else begin
            q <= {q[2:0], ~(q[3] ^ q[1])};  // Custom feedback polynomial
        end
    end
end

endmodule