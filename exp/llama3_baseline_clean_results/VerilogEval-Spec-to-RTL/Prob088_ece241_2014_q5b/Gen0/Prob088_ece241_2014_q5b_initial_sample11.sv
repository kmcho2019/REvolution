module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

// One-hot encoding for states A and B
reg [1:0] state;
reg [1:0] nextState;

// Output logic
assign z = (state[1] | (state[0] & x));

// Next state logic
always @(*) begin
    case(state)
        2'b10: begin // State A
            if(x) begin
                nextState = 2'b01; // Go to B
            end else begin
                nextState = 2'b10; // Stay in A
            end
        end
        2'b01: begin // State B
            nextState = 2'b01; // Always stay in B
        end
        default: begin
            nextState = 2'b10; // Default state is A
        end
    endcase
end

// Sequential logic (state register)
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b10; // Reset to state A
    end else begin
        state <= nextState;
    end
end

endmodule