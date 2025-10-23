module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    // Define states for FSM
    localparam HOLD_4 = 1'b0;
    localparam COUNT  = 1'b1;

    reg state;

    always @(posedge clk) begin
        case (state)
            HOLD_4: begin
                if (a)
                    q <= 3'd4;          // Hold q=4 when a=1
                else begin
                    q <= 3'd0;          // Reset counter start at 0 on transition to COUNT
                    state <= COUNT;
                end
            end
            COUNT: begin
                if (a) begin
                    q <= 3'd4;          // Switch back to HOLD_4 state with q=4
                    state <= HOLD_4;
                end
                else begin
                    // increment q modulo 7
                    if (q == 3'd6)
                        q <= 3'd0;
                    else
                        q <= q + 3'd1;
                end
            end
            default: begin
                // Initialize state and output on unknown
                state <= HOLD_4;
                q <= 3'd4;
            end
        endcase
    end

endmodule