module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg [1:0] state; // Using 2 bits to represent the states (OFF=2'b00, ON=2'b01)
reg [1:0] next_state;
assign out = (state == 2'b01)? 1'b1 : 1'b0; // Moore machine output based on state

// State transitions
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b00; // Reset to OFF state
    end else begin
        case(state)
            2'b00: begin // OFF state
                if(j == 1'b1) begin
                    state <= 2'b01; // Transition to ON state if j is 1
                end else begin
                    state <= 2'b00; // Stay in OFF state if j is 0
                end
            end
            2'b01: begin // ON state
                if(k == 1'b1) begin
                    state <= 2'b00; // Transition to OFF state if k is 1
                end else begin
                    state <= 2'b01; // Stay in ON state if k is 0
                end
            end
            default: state <= 2'b00; // Default to OFF state for any other condition
        endcase
    end
end

endmodule