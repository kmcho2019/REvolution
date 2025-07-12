`timescale 1ns/1ps

module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// Define states as an enumeration
enum logic [2:0] {
    A, // Beginning state
    B, // State after reset de-asserted
    C, // Monitoring x for sequence 1, 0, 1
    D, // Seen sequence, setting g to 1 and monitoring y
    E, // Maintain g = 1 permanently
    F  // Set g = 0 permanently
} state, next_state;

// Counter for clock cycles in state D
logic [1:0] counter;

// Initialize state and counter
initial begin
    state = A;
    counter = 2'b00;
end

// Assign outputs based on state
always_comb begin
    f = 1'b0;
    g = 1'b0;
    case (state)
        B: f = 1'b1;
        D: g = 1'b1;
        E: g = 1'b1;
        default: ;
    endcase
end

// Determine next state
always_comb begin
    next_state = state;
    case (state)
        A: if (!resetn) next_state = A;
           else next_state = B;
        B: next_state = C;
        C: if (x) next_state = C1;
           else if (~x) next_state = C;
           else next_state = C;
        C1: if (~x) next_state = C2;
           else next_state = C;
        C2: if (x) next_state = D;
           else next_state = C;
        D: begin
            counter = counter + 1'b1;
            if (y || (counter == 2'b10)) next_state = E;
            else if (counter == 2'b10) next_state = F;
        end
        E: next_state = E;
        F: next_state = F;
        default: next_state = A;
    endcase
end

// Update state on positive edge of clock
always_ff @(posedge clk) begin
    if (~resetn) begin
        state <= A;
        counter <= 2'b00;
    end
    else begin
        state <= next_state;
    end
end

// States for sequence detection (not explicitly defined in the initial enum)
logic C1, C2;

// Internal wires for sequence detection
wire seq_x1, seq_x2;

assign seq_x1 = x;
assign seq_x2 = ~x;

always_comb begin
    if (seq_x1) next_state = C1;
    else if (seq_x2) next_state = C2;
    else next_state = C;
end

endmodule