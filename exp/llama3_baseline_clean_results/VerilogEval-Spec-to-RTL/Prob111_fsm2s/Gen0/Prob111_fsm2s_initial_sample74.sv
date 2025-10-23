module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // Define parameters for states
    parameter OFF = 0;
    parameter ON  = 1;

    // Declare current state variable
    reg current_state;
    reg next_state;

    // Output logic
    assign out = (current_state == ON) ? 1'b1 : 1'b0;

    // State transition logic
    always @(*) begin
        case (current_state)
            OFF: begin
                if (j) next_state = ON;
                else next_state = OFF;
            end
            ON: begin
                if (k) next_state = OFF;
                else next_state = ON;
            end
            default: next_state = OFF;
        endcase
    end

    // Synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            current_state <= OFF;
        end else begin
            current_state <= next_state;
        end
    end

endmodule