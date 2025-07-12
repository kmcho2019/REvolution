module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg [0:0] state; // Using a single bit for two states
reg [0:0] next_state;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 0; // Reset to OFF state
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        0: begin // State OFF
            if(j) begin
                next_state = 1; // Transition to ON
            end else begin
                next_state = 0; // Stay in OFF
            end
        end
        1: begin // State ON
            if(k) begin
                next_state = 0; // Transition to OFF
            end else begin
                next_state = 1; // Stay in ON
            end
        end
        default: next_state = 0; // Default to OFF if state is unknown
    endcase
end

always @(*) begin
    case(state)
        0: out = 0; // Output in OFF state
        1: out = 1; // Output in ON state
        default: out = 0; // Default output if state is unknown
    endcase
end

endmodule