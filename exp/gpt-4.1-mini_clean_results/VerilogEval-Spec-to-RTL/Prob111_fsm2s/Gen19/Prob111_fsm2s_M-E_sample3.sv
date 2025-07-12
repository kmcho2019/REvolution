module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // One-hot state bits
    reg off_state, on_state;
    reg next_off_state, next_on_state;

    // Next state logic
    always @(*) begin
        // Defaults to current states to avoid latches
        next_off_state = off_state;
        next_on_state  = on_state;
        case ({off_state, on_state})
            2'b10: // OFF state
                if (j)
                    begin
                        next_off_state = 1'b0;
                        next_on_state  = 1'b1;
                    end
                else
                    begin
                        next_off_state = 1'b1;
                        next_on_state  = 1'b0;
                    end
            2'b01: // ON state
                if (k)
                    begin
                        next_off_state = 1'b1;
                        next_on_state  = 1'b0;
                    end
                else
                    begin
                        next_off_state = 1'b0;
                        next_on_state  = 1'b1;
                    end
            default: // Reset to OFF
                begin
                    next_off_state = 1'b1;
                    next_on_state  = 1'b0;
                end
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            off_state <= 1'b1;
            on_state  <= 1'b0;
        end else begin
            off_state <= next_off_state;
            on_state  <= next_on_state;
        end
    end

    // Output depends only on ON state (Moore FSM)
    assign out = on_state;

endmodule