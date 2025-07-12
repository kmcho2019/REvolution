module TopModule(clk, a, q);
    input clk, a;
    output [2:0] q;

    reg [2:0] q;
    reg state;

    // Define states
    parameter STATE_A_HIGH = 1'b0;
    parameter STATE_A_LOW = 1'b1;

    always @(posedge clk) begin
        if (a) begin
            // Transition to STATE_A_HIGH
            state <= STATE_A_HIGH;
            q <= 4;
        end else if (~a && (state == STATE_A_HIGH)) begin
            // Transition to STATE_A_LOW
            state <= STATE_A_LOW;
            q <= 4; // Since it's the first transition, q should remain 4
        end else if (~a && (state == STATE_A_LOW)) begin
            // Increment q in STATE_A_LOW
            if (q == 7) begin
                // Wrap around from 7 to 0
                q <= 0;
            end else begin
                q <= q + 1;
            end
        end
    end
endmodule