module TopModule(
    input clk,
    input areset,
    input in,
    output out
    );

reg state;
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1; // Reset to state B
    end else begin
        case(state)
            1'b0: begin // State A
                if(in == 1'b1) begin
                    state <= 1'b0; // Stay in A
                end else begin
                    state <= 1'b1; // Go to B
                end
            end
            1'b1: begin // State B
                if(in == 1'b1) begin
                    state <= 1'b1; // Stay in B
                end else begin
                    state <= 1'b0; // Go to A
                end
            end
        endcase
    end
end

assign out = state; // Output is the current state

endmodule