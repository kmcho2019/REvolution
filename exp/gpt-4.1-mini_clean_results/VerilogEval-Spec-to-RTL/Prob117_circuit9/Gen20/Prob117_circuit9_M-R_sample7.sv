module TopModule (
    input clk,
    input rst_n,  // Active low synchronous reset
    input a,
    output reg [2:0] q
);

    localparam MODULO = 7;
    localparam CONST_FOUR = 3'd4;

    wire [2:0] next_q;

    // Combinational next state logic
    assign next_q = (a) ? CONST_FOUR :
                    (q == MODULO - 1) ? 3'd0 :
                    q + 3'd1;

    // Sequential state register with synchronous reset
    always @(posedge clk) begin
        if (!rst_n)
            q <= 3'd0;
        else
            q <= next_q;
    end

endmodule