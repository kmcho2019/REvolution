module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state; // Current state: 0 - A, 1 - B
reg next_state; // Next state
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1; // Reset to state B
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        1'b0: begin // State A
            if(in == 1'b1) begin
                next_state = 1'b0; // Stay in A if in is 1
            end else begin
                next_state = 1'b1; // Go to B if in is 0
            end
            out = 1'b0; // Output is 0 in state A
        end
        1'b1: begin // State B
            if(in == 1'b1) begin
                next_state = 1'b1; // Stay in B if in is 1
            end else begin
                next_state = 1'b0; // Go to A if in is 0
            end
            out = 1'b1; // Output is 1 in state B
        end
    endcase
end

endmodule