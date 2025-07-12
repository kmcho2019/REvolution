module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // Using 1 bit to represent the state (0 for A, 1 for B)
reg [0:0] next_state; // Next state

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1; // Reset to state B
    end else begin
        state <= next_state; // Update state on clock edge
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
        end
        1'b1: begin // State B
            if(in == 1'b0) begin
                next_state = 1'b0; // Go to A if in is 0
            end else begin
                next_state = 1'b1; // Stay in B if in is 1
            end
        end
    endcase
end

assign out = state; // Output corresponds to the current state

endmodule