module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the one-hot encoding for each state
localparam A = 4'b0001;
localparam B = 4'b0010;
localparam C = 4'b0100;
localparam D = 4'b1000;

// State register
reg [3:0] state;

// Next state logic
always_comb begin
    case (1'b1)
        state[0]: state = in? B : A; // A
        state[1]: state = in? B : C; // B
        state[2]: state = in? D : A; // C
        state[3]: state = in? B : C; // D
        default: state = A;
    endcase
end

// Output logic
always_comb begin
    out = (state == D)? 1'b1 : 1'b0;
end

// Sequential logic for state transition
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        // No need to assign next_state, we are using always_comb to calculate state
    end
end

endmodule