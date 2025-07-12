module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state_a; // State A signal
reg state_b; // State B signal

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state_a <= 1'b1; // Reset to state A
        state_b <= 1'b0;
    end else begin
        case({state_a, state_b})
            2'b10: begin // State A
                if(~x) begin
                    state_a <= 1'b1;
                    state_b <= 1'b0;
                end else begin
                    state_a <= 1'b0;
                    state_b <= 1'b1;
                end
            end
            2'b01: begin // State B
                state_a <= 1'b0;
                state_b <= 1'b1;
            end
            default: begin
                state_a <= 1'b1;
                state_b <= 1'b0;
            end
        endcase
    end
end

always @(state_a or state_b or x) begin
    if(state_a) begin
        z = x;
    end else if(state_b) begin
        z = ~x;
    end else begin
        z = 1'b0;
    end
end

endmodule