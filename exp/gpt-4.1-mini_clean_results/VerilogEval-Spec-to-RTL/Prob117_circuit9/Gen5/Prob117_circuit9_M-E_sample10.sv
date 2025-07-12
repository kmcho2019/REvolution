module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    wire [3:0] sum;
    reg [2:0] next_q;

    assign sum = q + 1'b1;

    always @(*) begin
        if (a)
            next_q = 3'd4;
        else
            next_q = (sum == 4'd7) ? 3'd0 : sum[2:0];
    end

    always @(posedge clk) begin
        if (q != next_q)  // Update only if value changes to reduce switching
            q <= next_q;
    end

endmodule