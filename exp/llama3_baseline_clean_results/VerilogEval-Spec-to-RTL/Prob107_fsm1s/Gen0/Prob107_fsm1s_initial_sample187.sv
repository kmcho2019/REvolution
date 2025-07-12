module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg state; // Using a reg for sequential logic
always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 1'b1; // Reset to state B
    end else begin
        case(state)
            1'b1: begin // State B
                if(!in) begin
                    state <= 1'b0; // Transition to A on in=0
                end
            end
            1'b0: begin // State A
                if(!in) begin
                    state <= 1'b1; // Transition to B on in=0
                end
            end
            default: state <= 1'b1; // Default to state B
        endcase
    end
end

assign out = state; // Continuous assignment for output logic

endmodule