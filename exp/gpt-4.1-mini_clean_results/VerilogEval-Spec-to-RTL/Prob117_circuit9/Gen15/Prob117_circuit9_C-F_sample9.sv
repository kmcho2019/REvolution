module TopModule (
    input clk,
    input rst,       // synchronous active-high reset
    input a,
    output reg [2:0] q
);

    localparam [2:0] CONST_FOUR = 3'd4;
    localparam [2:0] MODULO = 3'd7;

    wire [2:0] next_q;

    // Combinational next state logic
    assign next_q = a ? CONST_FOUR : 
                    (q == 3'd4) ? 3'd5 :
                    (q == 3'd5) ? 3'd6 :
                    (q == 3'd6) ? 3'd0 :
                    (q == 3'd0) ? 3'd1 :
                    (q == 3'd1) ? 3'd2 :
                    (q == 3'd2) ? 3'd3 :
                    3'd4; // default fallback to 4 if q==3 or invalid

    always @(posedge clk) begin
        if (rst)
            q <= 3'd0;
        else
            q <= next_q;
    end

endmodule