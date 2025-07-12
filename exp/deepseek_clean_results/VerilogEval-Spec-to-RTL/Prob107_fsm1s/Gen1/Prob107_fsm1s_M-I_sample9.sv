module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Define states - using binary encoding (most efficient for 2 states)
    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;

    reg state;  // Current state register (1 bit)

    // Optimized state transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;  // Synchronous reset to state B
        end else begin
            case (state)
                STATE_B: state <= (in == 1'b1) ? STATE_B : STATE_A;
                STATE_A: state <= (in == 1'b1) ? STATE_A : STATE_B;
            endcase
        end
    end

    // Output logic remains combinational (Moore machine)
    assign out = ~state;  // Equivalent to (state == STATE_B) but uses less logic

endmodule