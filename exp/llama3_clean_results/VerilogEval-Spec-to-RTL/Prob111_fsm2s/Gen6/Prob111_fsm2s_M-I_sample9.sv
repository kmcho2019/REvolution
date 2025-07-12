module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // Binary encoding (0 for OFF, 1 for ON)
reg next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        1'b0: begin // OFF state
            next_state = j ? 1'b1 : 1'b0;
        end
        1'b1: begin // ON state
            next_state = k ? 1'b0 : 1'b1;
        end
    endcase
end

assign out = state; // Output directly determined by the current state

endmodule