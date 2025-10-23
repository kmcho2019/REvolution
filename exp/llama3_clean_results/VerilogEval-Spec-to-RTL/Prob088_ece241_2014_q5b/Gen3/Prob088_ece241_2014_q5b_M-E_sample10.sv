module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // Binary counter for state management

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b00; // Reset to state A
    end else begin
        if(x && (state == 2'b00)) begin // Transition to B if x is 1 and in state A
            state <= 2'b01;
        end else begin // Stay in current state
            state <= state;
        end
    end
end

always @(*) begin
    if(state == 2'b01) begin // State B
        z = ~x;
    end else begin // State A
        z = x;
    end
end

endmodule