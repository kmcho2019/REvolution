module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
    );

reg state; // 1-bit register to hold the current state
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1; // Reset to state B
    end else begin
        case(state)
            1'b0: begin // State A
                if(!in) begin
                    state <= 1; // Transition to B on in = 0
                end else begin
                    state <= 0; // Stay in A on in = 1
                end
            end
            1'b1: begin // State B
                if(!in) begin
                    state <= 0; // Transition to A on in = 0
                end else begin
                    state <= 1; // Stay in B on in = 1
                end
            end
        endcase
    end
end

assign out = state; // Output reflects the current state

endmodule