module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);
    reg [2:0] next_q;

    always @(*) begin
        if (a)
            next_q = 3'd4;
        else
            next_q = (q == 3'd6) ? 3'd0 : q + 3'd1;
    end

    always @(posedge clk) begin
        q <= next_q;
    end
endmodule