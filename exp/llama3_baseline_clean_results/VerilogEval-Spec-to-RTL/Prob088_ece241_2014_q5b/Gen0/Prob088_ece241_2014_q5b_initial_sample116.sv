module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] current_state;
reg [1:0] next_state;

// Define the initial state (A) as one-hot encoded (2'b01)
initial current_state = 2'b01;

always @(*) begin
    case(current_state)
        2'b01: // State A
            if (x == 0) begin
                next_state = 2'b01; // Stay in state A
                z = 0;
            end else begin
                next_state = 2'b10; // Go to state B
                z = 1;
            end
        2'b10: // State B
            if (x == 0 || x == 1) begin
                next_state = 2'b10; // Stay in state B
                z = 1;
            end
        default: // Invalid state (should not happen)
            next_state = 2'b01; // Reset to state A
            z = 0;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 2'b01; // Asynchronous reset to state A
    end else begin
        current_state <= next_state;
    end
end

endmodule