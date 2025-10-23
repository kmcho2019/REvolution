module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    // Next state logic encoded as a combinational block
    reg [2:0] next_q;

    always @(*) begin
        if (a) begin
            // Hold q at 4 when a is high
            next_q = 3'd4;
        end else begin
            // When a is low, count up modulo 7 starting from current q
            case (q)
                3'd0: next_q = 3'd1;
                3'd1: next_q = 3'd2;
                3'd2: next_q = 3'd3;
                3'd3: next_q = 3'd4;
                3'd4: next_q = 3'd5;
                3'd5: next_q = 3'd6;
                3'd6: next_q = 3'd0;
                default: next_q = 3'd0; // fallback for X or undefined
            endcase
        end
    end

    // State register update
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule