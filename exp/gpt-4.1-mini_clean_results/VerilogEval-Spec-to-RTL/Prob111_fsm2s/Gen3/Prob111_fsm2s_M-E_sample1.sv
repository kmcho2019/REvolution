module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    // State encoding using localparam for readability
    localparam OFF = 1'b0,
               ON  = 1'b1;

    reg state, next_state;
    reg next_out;

    // Combinational block: Determine next state and output based on current state and inputs
    always @(*) begin
        case (state)
            OFF: begin
                next_out = 1'b0;            // output when OFF
                next_state = (j) ? ON : OFF;
            end
            ON: begin
                next_out = 1'b1;            // output when ON
                next_state = (k) ? OFF : ON;
            end
            default: begin
                next_out = 1'b0;
                next_state = OFF;
            end
        endcase
    end

    // Sequential block: State and output update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out <= 1'b0;
        end else begin
            state <= next_state;
            out <= next_out;
        end
    end

endmodule