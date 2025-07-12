module TopModule (
    input        clk,
    input        a,
    output reg [2:0] q
);

    localparam MODULO      = 7;
    localparam STATE_FOUR  = 3'd4;

    reg [2:0] next_q;

    // Combinational next state logic
    always @(*) begin
        if (a) begin
            if (q == STATE_FOUR)
                next_q = q;             // Hold q at 4 to reduce toggling
            else
                next_q = STATE_FOUR;    // Move to 4 if not already there
        end else begin
            case (q)
                3'd4: next_q = 3'd5;
                3'd5: next_q = 3'd6;
                3'd6: next_q = 3'd0;
                3'd0: next_q = 3'd1;
                3'd1: next_q = 3'd2;
                3'd2: next_q = 3'd3;
                3'd3: next_q = 3'd4;
                default: next_q = STATE_FOUR; // Recover invalid state to 4
            endcase
        end
    end

    // Sequential state update on rising edge of clk
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule