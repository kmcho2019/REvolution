module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] q
);

    wire reached_ten = (q == 4'd10);
    wire ce = ~reset;

    always @(posedge clk) begin
        if (reset)
            q <= 4'd1;
        else if (ce) begin
            if (reached_ten)
                q <= 4'd1;
            else
                q <= q + 1'b1;
        end
    end

endmodule