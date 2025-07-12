module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state, next_state;

    // Combinational next-state and output logic (Moore machine)
    always @(*) begin
        case(state)
            OFF: begin
                next_state = j ? ON : OFF;
                // output will be registered, so assign next_state only here
            end
            ON: begin
                next_state = k ? OFF : ON;
            end
            default: begin
                next_state = OFF;
            end
        endcase
    end

    // Sequential block for state register and registered output with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
            out <= 1'b0;
        end else begin
            state <= next_state;
            // Output depends only on state (Moore)
            out <= (next_state == ON) ? 1'b1 : 1'b0;
        end
    end

endmodule