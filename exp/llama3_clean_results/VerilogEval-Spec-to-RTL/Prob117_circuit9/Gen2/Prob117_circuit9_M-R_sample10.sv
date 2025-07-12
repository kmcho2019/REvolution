module TopModule(clk, a, q);
    input clk, a;
    output [2:0] q;

    reg [2:0] q;
    reg [1:0] state; // 0: idle, 1: asserted, 2: incrementing

    always @(posedge clk) begin
        case (state)
            0: begin // idle
                if (a) begin
                    state <= 1; // transition to asserted state
                    q <= 4;
                end
            end
            1: begin // asserted
                if (!a) begin
                    state <= 2; // transition to incrementing state
                end
            end
            2: begin // incrementing
                if (q == 7) begin
                    q <= 0; // wrap around
                end else begin
                    q <= q + 1;
                end
            end
            default: state <= 0;
        endcase
    end
endmodule