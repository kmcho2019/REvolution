module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

    reg state; // 0 = B, 1 = A
    reg next_state;

    // Next-state combinational logic
    always @(*) begin
        case (state)
            1'b0: // B state
                next_state = (in == 1'b0) ? 1'b1 : 1'b0;
            1'b1: // A state
                next_state = (in == 1'b0) ? 1'b0 : 1'b1;
            default:
                next_state = 1'b0;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 1'b0; // B state
        else
            state <= next_state;
    end

    // Output depends only on current state (Moore output)
    assign out = ~state;

endmodule