module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // One-hot state representation: OFF=2'b10, ON=2'b01
    reg state_off, state_on;
    reg next_state_off, next_state_on;

    // Next state combinational logic
    always @(*) begin
        // Default hold current values
        next_state_off = state_off;
        next_state_on  = state_on;

        if (state_off) begin
            // From OFF: j=0 stay OFF, j=1 go ON
            if (j)
                begin
                    next_state_off = 1'b0;
                    next_state_on  = 1'b1;
                end
            else
                begin
                    next_state_off = 1'b1;
                    next_state_on  = 1'b0;
                end
        end else if (state_on) begin
            // From ON: k=0 stay ON, k=1 go OFF
            if (k)
                begin
                    next_state_off = 1'b1;
                    next_state_on  = 1'b0;
                end
            else
                begin
                    next_state_off = 1'b0;
                    next_state_on  = 1'b1;
                end
        end else begin
            // Invalid state, default to OFF
            next_state_off = 1'b1;
            next_state_on  = 1'b0;
        end
    end

    // State register update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state_off <= 1'b1;
            state_on  <= 1'b0;
        end else begin
            state_off <= next_state_off;
            state_on  <= next_state_on;
        end
    end

    // Output is high when in ON state
    assign out = state_on;

endmodule