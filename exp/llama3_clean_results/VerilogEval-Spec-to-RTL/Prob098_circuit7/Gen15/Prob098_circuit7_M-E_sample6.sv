module TopModule(
    input clk,
    input a,
    output reg q
);

reg [1:0] state; // 2 states: 0 (q=1) and 1 (q=0)

always @(posedge clk) begin
    case (state)
        2'b00: begin // State 0: q = 1
            if (a == 1'b0) begin
                state <= 2'b00; // Stay in state 0
                q <= 1'b1;
            end else begin
                state <= 2'b01; // Transition to state 1
                q <= 1'b0;
            end
        end
        2'b01: begin // State 1: q = 0
            if (a == 1'b1) begin
                state <= 2'b01; // Stay in state 1
                q <= 1'b0;
            end else begin
                state <= 2'b00; // Transition to state 0
                q <= 1'b1;
            end
        end
        default: begin
            state <= 2'b00; // Reset to state 0
            q <= 1'b1;
        end
    endcase
end

initial begin
    state = 2'b00; // Initialize state to 0
    q = 1'b1; // Initialize q to 1
end

endmodule