module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] next_q;

    always @* begin
        if (reset)
            next_q = 4'd1;  // reset sets counter to 1
        else if (q == 4'd10)
            next_q = 4'd1;  // wrap around after 10
        else
            next_q = q + 1'b1;
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule