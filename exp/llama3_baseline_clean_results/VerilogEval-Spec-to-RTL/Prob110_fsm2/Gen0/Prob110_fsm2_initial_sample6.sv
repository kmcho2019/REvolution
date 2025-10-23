module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg [1:0] state; // Using 2 bits to represent states, but we only need 2 states (OFF and ON), so 1 bit would suffice
parameter OFF = 0, ON = 1;

always @(*) begin
    if (areset) begin
        state = OFF;
        out = 0;
    end else begin
        case(state)
            OFF: begin
                if (j) begin
                    state = ON;
                    out = 1;
                end else begin
                    state = OFF;
                    out = 0;
                end
            end
            ON: begin
                if (k) begin
                    state = OFF;
                    out = 0;
                end else begin
                    state = ON;
                    out = 1;
                end
            end
            default: state = OFF; // Default state in case of invalid states
        endcase
    end
end

endmodule