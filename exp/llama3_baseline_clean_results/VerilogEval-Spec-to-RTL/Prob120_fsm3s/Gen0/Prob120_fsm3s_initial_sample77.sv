module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define the states
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// Declare the current and next states
reg [1:0] current_state;
reg [1:0] next_state;

// Assign the output based on the current state
always @(current_state) begin
    case (current_state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
    endcase
end

// Determine the next state based on the current state and input value
always @(current_state, in) begin
    case (current_state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
    endcase
end

// Update the current state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule