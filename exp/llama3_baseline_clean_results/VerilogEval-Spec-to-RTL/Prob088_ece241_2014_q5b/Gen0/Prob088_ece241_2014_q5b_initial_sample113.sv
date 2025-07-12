module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state; // Using one-hot encoding, so 2 bits for 2 states
reg [1:0] nextState;

// Outputs
assign z = (state == 2'b01) ? x : 1'b1;

// Combinational Logic for Next State
always @(*) begin
    case(state)
        2'b01: // State A
            if(x == 1'b0) begin
                nextState = 2'b01; // Stay in A
            end else begin
                nextState = 2'b10; // Go to B
            end
        2'b10: // State B
            nextState = 2'b10; // Stay in B regardless of x
        default: begin
            nextState = 2'b01; // Default state, should never reach here ideally
        end
    endcase
end

// Sequential Logic
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        state <= nextState;
    end
end

initial begin
    state = 2'b01; // Initial state
end

endmodule