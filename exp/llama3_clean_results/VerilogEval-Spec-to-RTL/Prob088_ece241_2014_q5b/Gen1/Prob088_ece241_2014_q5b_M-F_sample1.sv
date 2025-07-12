module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

// Define states
parameter A = 2'b01;
parameter B = 2'b10;

// Current state
reg [1:0] current_state;

// Next state
reg [1:0] next_state;

// Initialize current state
initial current_state = A;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic for next state and output z
always @* begin
    case (current_state)
        A: begin
            if (x) begin
                next_state = B;
                z = 1'b1;
            end else begin
                next_state = A;
                z = 1'b0;
            end
        end
        B: begin
            next_state = B; // Since in state B, next state is always B
            z = 1'b1; // And output z is always 1 in state B
        end
        default: begin
            next_state = A;
            z = 1'b0;
        end
    endcase
end

endmodule