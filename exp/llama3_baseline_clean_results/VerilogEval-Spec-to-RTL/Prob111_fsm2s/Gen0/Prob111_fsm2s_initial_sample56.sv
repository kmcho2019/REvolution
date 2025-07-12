module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg [0:0] state; // State register, 1 bit is enough for 2 states
parameter OFF = 1'b0, ON = 1'b1;

always @(posedge clk) begin
    if (reset) begin // Active-high synchronous reset
        state <= OFF;
    end else begin
        case (state)
            OFF: begin
                if (j) begin
                    state <= ON;
                end else begin
                    state <= OFF;
                end
            end
            ON: begin
                if (k) begin
                    state <= OFF;
                end else begin
                    state <= ON;
                end
            end
            default: state <= OFF; // Default to OFF state
        endcase
    end
end

always @(*) begin
    case (state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
        default: out = 1'b0; // Default output to 0
    endcase
end

endmodule