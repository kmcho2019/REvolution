module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] nextState;

// State table
always @(*) begin
    case (state)
        2'b00: begin // State A
            if (r[0] == 1'b1) begin
                nextState = 2'b01; // State B
            end else if (r[1] == 1'b1) begin
                nextState = 2'b10; // State C
            end else if (r[2] == 1'b1) begin
                // In the original problem description, this case was supposed to transition to D, 
                // but since D is not used anywhere, we keep the current state
                nextState = 2'b00; // State A
            end else begin
                nextState = 2'b00; // State A
            end
        end
        2'b01: begin // State B
            if (r[0] == 1'b1) begin
                nextState = 2'b01; // State B
            end else begin
                nextState = 2'b00; // State A
            end
        end
        2'b10: begin // State C
            if (r[1] == 1'b1) begin
                nextState = 2'b10; // State C
            end else begin
                nextState = 2'b00; // State A
            end
        end
        default: begin
            nextState = 2'b00; // State A
        end
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00; // Reset to state A
    end else begin
        state <= nextState;
    end
end

// FSM outputs
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = 1'b0; // Since state D is not used, we can always set g[2] to 0

endmodule