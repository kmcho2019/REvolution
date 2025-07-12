module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    wire reached_ten = q[3] & ~q[2] & q[1] & ~q[0]; // detect decimal 10
    
    reg [3:0] next_q;

    always @(*) begin
        if (reset)
            next_q = 4'd1;
        else if (reached_ten)
            next_q = 4'd1;
        else
            next_q = q + 1'b1;
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule