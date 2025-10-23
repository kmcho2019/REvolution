module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states as one-hot values
localparam A = 4'b0001;
localparam B = 4'b0010;
localparam C = 4'b0100;
localparam D = 4'b1000;

// State register
reg [3:0] state;

// Next state logic
reg [3:0] next_state;

// State transition table
reg [3:0] state_trans [3:0] [1:0];

// Initialize state transition table
initial begin
    state_trans[A][0] = A;
    state_trans[A][1] = B;
    state_trans[B][0] = C;
    state_trans[B][1] = B;
    state_trans[C][0] = A;
    state_trans[C][1] = D;
    state_trans[D][0] = C;
    state_trans[D][1] = B;
end

// Combinational logic for next state determination
always_comb begin
    case (state)
        A: next_state = in? state_trans[A][1] : state_trans[A][0];
        B: next_state = in? state_trans[B][1] : state_trans[B][0];
        C: next_state = in? state_trans[C][1] : state_trans[C][0];
        D: next_state = in? state_trans[D][1] : state_trans[D][0];
    endcase
end

// Sequential logic for state transition
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Assign output based on current state
always_comb begin
    case (state)
        A, B, C: out = 0;
        D: out = 1;
    endcase
end

endmodule