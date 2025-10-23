module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states
parameter A = 1'b0;
parameter B = 1'b1;

// Declare the current and next state signals
reg current_state;
reg next_state;

// Initialize the current state
initial current_state = B;

// Implement the next state logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= B;
    end else begin
        current_state <= next_state;
    end
end

// Implement the state transition logic
always @(*) begin
    case (current_state)
        A: begin
            if (~in) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        B: begin
            if (~in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
    endcase
end

// Implement the output logic (Moore machine output)
assign out = current_state;

endmodule