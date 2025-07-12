module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// One-hot encoded states
reg [3:0] state;

// Initialize state A
localparam A = 4'b0001;
localparam B = 4'b0010;
localparam C = 4'b0100;
localparam D = 4'b1000;

// Output logic
always_comb begin
    case (1'b1)
        state[0]: out = 0; // State A
        state[1]: out = 0; // State B
        state[2]: out = 0; // State C
        state[3]: out = 1; // State D
        default: out = 0;
    endcase
end

// Sequential logic for state transition
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        case (1'b1)
            state[0]: state <= in ? B : A; // From A
            state[1]: state <= in ? B : C; // From B
            state[2]: state <= in ? D : A; // From C
            state[3]: state <= in ? B : C; // From D
            default: state <= A;
        endcase
    end
end

endmodule