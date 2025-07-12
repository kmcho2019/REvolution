module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg [1:0] state; // 0: OFF, 1: ON

always @ (posedge clk) begin
    if (reset) begin // synchronous reset
        state <= 0; // reset to OFF state
    end else begin
        case (state)
            0: begin // OFF state
                if (j) begin
                    state <= 1; // transition to ON state
                end
            end
            1: begin // ON state
                if (k) begin
                    state <= 0; // transition to OFF state
                end
            end
            default: state <= 0; // default to OFF state
        endcase
    end
end

always @ (*) begin
    case (state)
        0: out <= 0; // output 0 in OFF state
        1: out <= 1; // output 1 in ON state
        default: out <= 0; // default output 0
    endcase
end

endmodule