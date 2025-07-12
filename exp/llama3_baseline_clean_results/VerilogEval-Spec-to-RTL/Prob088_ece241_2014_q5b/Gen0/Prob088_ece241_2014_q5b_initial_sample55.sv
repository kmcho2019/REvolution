module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // One-hot encoding
reg [1:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        2'b01: begin // State A
            if (x == 0) begin
                next_state = 2'b01;
                z = 0;
            end else begin
                next_state = 2'b10;
                z = 1;
            end
        end
        2'b10: begin // State B
            next_state = 2'b10;
            z = x;
        end
        default: begin // This should not happen in a correctly designed FSM
            next_state = 2'b01; // Default to state A if in an unknown state
            z = 0;
        end
    endcase
end

endmodule