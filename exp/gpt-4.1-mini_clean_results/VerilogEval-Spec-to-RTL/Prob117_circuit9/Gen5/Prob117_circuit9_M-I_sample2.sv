module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] next_q;

// Combinational next state logic with arithmetic modulo-7 increment
always @(*) begin
    if (a) begin
        next_q = 3'd4;
    end else begin
        if (q > 3'd6) begin
            // Recover invalid state
            next_q = 3'd4;
        end else if (q == 3'd6) begin
            next_q = 3'd0;
        end else begin
            next_q = q + 3'd1;
        end
    end
end

// Sequential update of q
always @(posedge clk) begin
    q <= next_q;
end

endmodule