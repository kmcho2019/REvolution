module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;
reg [1:0] nextState;

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= 2'b00; // Idle state
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case(state)
        2'b00: begin // Idle state
            if (x) begin
                nextState = 2'b01; // Seen_1 state
            end else begin
                nextState = 2'b00; // Stay in Idle state
            end
        end
        2'b01: begin // Seen_1 state
            if (x) begin
                nextState = 2'b10; // Seen_10 state
            end else begin
                nextState = 2'b01; // Stay in Seen_1 state
            end
        end
        2'b10: begin // Seen_10 state
            if (x) begin
                nextState = 2'b01; // Back to Seen_1 state
            end else begin
                nextState = 2'b10; // Stay in Seen_10 state
            end
        end
    endcase
end

assign z = (state == 2'b10) && (~x); // Set z to 1 when in Seen_10 state and x is 0

endmodule