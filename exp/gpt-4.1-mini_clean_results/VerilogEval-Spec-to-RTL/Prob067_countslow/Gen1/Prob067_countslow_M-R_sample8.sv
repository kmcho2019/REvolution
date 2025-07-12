module TopModule (
    input        clk,
    input        reset,
    input        slowena,
    output reg [3:0] q
);

    reg [3:0] next_q;

    // Combinational logic to determine the next count
    always @(*) begin
        if (reset)
            next_q = 4'd0;
        else if (slowena) begin
            if (q == 4'd9)
                next_q = 4'd0;
            else
                next_q = q + 1;
        end else
            next_q = q;
    end

    // Sequential logic to update the count on the clock edge
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule