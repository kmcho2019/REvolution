module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // Using one-hot encoding, but we actually only need one bit for two states
reg [1:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        2'b01: begin // State A
            if (x == 1'b0) begin
                next_state = 2'b01; // Stay in A
                z = 1'b0;
            end else begin
                next_state = 2'b10; // Move to B
                z = 1'b1;
            end
        end
        2'b10: begin // State B
            next_state = 2'b10; // Stay in B
            z = ~x; // Output z based on x
        end
        default: begin // This should not happen in a properly designed one-hot FSM
            next_state = 2'b01; // Safely reset to A
            z = 1'b0;
        end
    endcase
end

endmodule