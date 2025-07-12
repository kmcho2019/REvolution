module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg [0:0] state; // State variable, 0 for OFF, 1 for ON

always @(posedge clk or posedge areset) begin
    if(areset) begin // Asynchronous reset to OFF state
        state <= 0;
    end else begin
        case(state)
            0: begin // State OFF
                if(j) begin
                    state <= 1; // Transition to ON if j is 1
                end else begin
                    state <= 0; // Stay in OFF if j is 0
                end
            end
            1: begin // State ON
                if(k) begin
                    state <= 0; // Transition to OFF if k is 1
                end else begin
                    state <= 1; // Stay in ON if k is 0
                end
            end
            default: state <= 0; // Default to OFF state for any other state value
        endcase
    end
end

always @(*) begin // Combinational logic to determine output based on state
    case(state)
        0: out = 0; // Output is 0 when in OFF state
        1: out = 1; // Output is 1 when in ON state
        default: out = 0; // Default output to 0 for any other state value
    endcase
end

endmodule