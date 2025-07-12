module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define states
enum logic [2:0] {
    A, // Reset State
    B, // f=1 State
    C, // Monitor x State
    D, // g=1, Monitor y State
    E, // g=1 permanently State
    F  // g=0 permanently State
} state, next_state;

// Initialize state
initial state = A;

// Sequential logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        case (state)
            B: f <= 1;
            C, D, E, F: f <= 0;
            default: f <= 0;
        endcase
        case (state)
            E: g <= 1;
            F: g <= 0;
            default: g <= 0;
        endcase
    end
end

// Combinatorial logic
always @(*) begin
    case (state)
        A: if (resetn) next_state = B;
        B: next_state = C;
        C: begin
            static logic [1:0] seq = 2'b00;
            case (seq)
                2'b00: if (x) next_state = C; else next_state = C;
                2'b01: if (!x) next_state = C; else next_state = C;
                2'b10: if (x) next_state = D; else next_state = C;
                default: next_state = C;
            endcase
            if (x) seq = {seq[0], 1'b1};
            else seq = {seq[0], 1'b0};
            if (seq == 2'b101) seq = 2'b00;
        end
        D: begin
            static logic [1:0] y_seq = 2'b00;
            if (y || (y_seq == 2'b10)) next_state = E;
            else if (y_seq == 2'b11) next_state = F;
            else next_state = D;
            y_seq = {y_seq[0], y};
        end
        E, F: next_state = state;
        default: next_state = A;
    endcase
end

endmodule