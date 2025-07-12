module TopModule (
    input clk,
    input rst_n,    // Active low synchronous reset for defined initialization
    input a,
    output reg [2:0] q
);
    localparam MODULO   = 7;
    localparam JUMP_VAL = 3'd4;

    reg [2:0] next_q;

    // Combinational logic for next state
    always @(*) begin
        if (a)
            next_q = JUMP_VAL;  // Jump to 4 when 'a' is high
        else begin
            case (q)
                3'd0: next_q = 3'd1;
                3'd1: next_q = 3'd2;
                3'd2: next_q = 3'd3;
                3'd3: next_q = 3'd4;
                3'd4: next_q = 3'd5;
                3'd5: next_q = 3'd6;
                3'd6: next_q = 3'd0;
                default: next_q = 3'd0;
            endcase
        end
    end

    // Sequential logic with synchronous active-low reset
    always @(posedge clk) begin
        if (!rst_n)
            q <= 3'd0;
        else
            q <= next_q;
    end
endmodule