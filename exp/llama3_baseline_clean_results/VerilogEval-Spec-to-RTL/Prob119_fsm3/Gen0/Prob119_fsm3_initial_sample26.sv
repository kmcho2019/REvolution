module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define the states
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

reg [1:0] current_state;
reg [1:0] next_state;

// Determine the next state
always @(current_state or in) begin
    case (current_state)
        A: begin
            if (!in) next_state = A;
            else next_state = B;
        end
        B: begin
            if (!in) next_state = C;
            else next_state = B;
        end
        C: begin
            if (!in) next_state = A;
            else next_state = D;
        end
        D: begin
            if (!in) next_state = C;
            else next_state = B;
        end
    endcase
end

// Update the current state on the positive edge of the clock
always @(posedge clk or posedge areset) begin
    if (areset) current_state <= A;
    else current_state <= next_state;
end

// Determine the output based on the current state
always @(current_state) begin
    case (current_state)
        A, B, C: out <= 0;
        D: out <= 1;
    endcase
end

endmodule