module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the states using one-hot encoding
reg [3:0] current_state;
reg [3:0] next_state;

// Initialize the states
localparam A = 4'b0001;
localparam B = 4'b0010;
localparam C = 4'b0100;
localparam D = 4'b1000;

// State transition logic
always_comb begin
    case (1'b1)
        current_state[0]: next_state = in ? B : A; // State A
        current_state[1]: next_state = in ? B : C; // State B
        current_state[2]: next_state = in ? D : A; // State C
        current_state[3]: next_state = in ? B : C; // State D
        default: next_state = A; // Default state
    endcase
end

// Output logic
always_comb begin
    case (1'b1)
        current_state[0]: out = 1'b0; // State A
        current_state[1]: out = 1'b0; // State B
        current_state[2]: out = 1'b0; // State C
        current_state[3]: out = 1'b1; // State D
        default: out = 1'bx; // Default output
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule