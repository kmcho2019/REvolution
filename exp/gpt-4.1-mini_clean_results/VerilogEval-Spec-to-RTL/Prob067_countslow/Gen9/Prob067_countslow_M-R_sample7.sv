module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

    reg [3:0] next_q;

    always @(*) begin
        if (reset)
            next_q = 4'd0;
        else if (slowena)
            next_q = (q == 4'd9) ? 4'd0 : q + 4'd1;
        else
            next_q = q;
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule