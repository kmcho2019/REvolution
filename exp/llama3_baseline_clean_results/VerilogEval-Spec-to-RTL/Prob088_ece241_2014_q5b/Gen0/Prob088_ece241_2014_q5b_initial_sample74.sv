module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state; // one-hot encoding: 2 states, so 2 bits
reg [1:0] next_state;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b10; // Reset to state A (one-hot encoded)
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        2'b10: begin // State A
            if(x == 1'b0) begin
                next_state = 2'b10; // Stay in A if x is 0
                z = 1'b0; // Output z is 0 in state A when x is 0
            end else begin
                next_state = 2'b01; // Move to B if x is 1
                z = 1'b1; // Output z is 1 when transitioning from A to B
            end
        end
        2'b01: begin // State B
            if(x == 1'b0) begin
                next_state = 2'b01; // Stay in B if x is 0
                z = 1'b1; // Output z is 1 in state B when x is 0
            end else begin
                next_state = 2'b01; // Stay in B if x is 1
                z = 1'b0; // Output z is 0 in state B when x is 1
            end
        end
        default: begin
            next_state = 2'b10; // Default state is A
            z = 1'b0; // Default output z is 0
        end
    endcase
end

endmodule