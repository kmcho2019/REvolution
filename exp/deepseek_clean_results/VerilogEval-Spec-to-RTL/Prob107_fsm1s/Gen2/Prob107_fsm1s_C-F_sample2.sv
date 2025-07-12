module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Explicit state definitions
    parameter STATE_A = 1'b0;
    parameter STATE_B = 1'b1;
    
    reg state;

    // Combined state transition and reset logic
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;  // Synchronous reset to B
        end else begin
            case (state)
                STATE_A: state <= in ? STATE_A : STATE_B;
                STATE_B: state <= in ? STATE_B : STATE_A;
            endcase
        end
    end

    // Direct output assignment (Moore machine)
    assign out = (state == STATE_B);

endmodule