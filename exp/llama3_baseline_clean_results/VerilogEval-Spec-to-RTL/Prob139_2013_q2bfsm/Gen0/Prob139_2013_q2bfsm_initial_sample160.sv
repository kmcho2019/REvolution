module TopModule (
    input  logic clk,
    input  logic resetn,
    input  logic x,
    input  logic y,
    output logic f,
    output logic g
);

// Define the states
typedef enum logic [2:0] {
    A = 3'b001,
    B = 3'b010,
    C = 3'b011,
    D = 3'b100,
    E = 3'b101
} state_t;

// Current state and next state
state_t current_state, next_state;

// Counter for monitoring y input
logic [1:0] y_count;

// Output logic
assign f = (current_state == B);
assign g = (current_state == D || current_state == E) && (current_state != E) || (current_state == E && y_count != 0);

// Sequential logic
always_ff @(posedge clk) begin
    if (~resetn) begin
        current_state <= A;
        y_count <= 2'b00;
    end else begin
        current_state <= next_state;
        if (current_state == D) begin
            if (y) begin
                y_count <= 2'b11;
            end else if (y_count == 2'b11) begin
                y_count <= 2'b11;
            end else begin
                y_count <= y_count + 1'b1;
            end
        end else begin
            y_count <= 2'b00;
        end
    end
end

// Combinational logic
always_comb begin
    case (current_state)
        A: next_state = (resetn) ? B : A;
        B: next_state = C;
        C: next_state = (x == 1'b1) ? (next_state == C) ? C : C : 
                      (x == 1'b0) ? (next_state == C) ? D : C : 
                      C;
        default: next_state = (current_state == C && x == 1'b1 && y_count == 2'b11) ? D : 
                                (current_state == D && y_count == 2'b11) ? E : 
                                (current_state == D && y_count == 2'b10) ? E : 
                                (current_state == D && y_count == 2'b01) ? E : 
                                (current_state == D && y_count == 2'b00) ? D : 
                                (current_state == E) ? E : current_state;
    endcase
end

// Monitoring x input in state C
always_comb begin
    if (current_state == C) begin
        if (x == 1'b1) begin
            next_state = C;
        end else if (x == 1'b0) begin
            next_state = D;
        end
    end
end

// Modify state transition based on x sequence
logic [2:0] x_sequence;
always_ff @(posedge clk) begin
    if (~resetn) begin
        x_sequence <= 3'b000;
    end else if (current_state == C) begin
        x_sequence <= {x_sequence[1:0], x};
        if (x_sequence == 3'b101) begin
            next_state = D;
        end
    end else begin
        x_sequence <= 3'b000;
    end
end

endmodule