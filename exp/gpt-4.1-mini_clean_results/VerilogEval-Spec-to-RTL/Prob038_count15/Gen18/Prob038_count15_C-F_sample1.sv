module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] next_q;

    always @(*) begin
        // Next state computed by arithmetic increment, optimized by synthesis tools
        next_q = q + 1;
    end

    always @(posedge clk) begin
        if (reset)
            q <= 4'b0000;
        else
            q <= next_q;
    end

endmodule