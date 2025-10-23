module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [2:0] state; // Current state of the FSM (A=3'b000, B=3'b001, C=3'b010, D=3'b011, E=3'b100)
reg [1:0] w_count; // Count of w=1 in the last three clock cycles

always @(posedge clk) begin
    if(reset) begin
        state <= 3'b000; // Reset state A
        w_count <= 2'b00;
        z <= 1'b0;
    end
    else begin
        case(state)
            3'b000: begin // State A
                if(s) begin
                    state <= 3'b001; // Transition to state B
                    w_count <= 2'b00;
                end
                else begin
                    state <= 3'b000; // Stay in state A
                end
                z <= 1'b0;
            end
            3'b001: begin // State B
                if(w) begin
                    w_count <= w_count + 1; // Increment w_count if w=1
                end
                state <= 3'b010; // Transition to state C
            end
            3'b010: begin // State C
                if(w) begin
                    w_count <= w_count + 1; // Increment w_count if w=1
                end
                state <= 3'b011; // Transition to state D
            end
            3'b011: begin // State D
                if(w) begin
                    w_count <= w_count + 1; // Increment w_count if w=1
                end
                state <= 3'b100; // Transition to state E
            end
            3'b100: begin // State E
                if(w_count == 2) begin
                    z <= 1'b1; // Set z=1 if w was 1 exactly twice
                end
                else begin
                    z <= 1'b0;
                end
                w_count <= 2'b00; // Reset w_count
                state <= 3'b001; // Transition back to state B
            end
        endcase
    end
end

endmodule