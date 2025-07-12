module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Enumerations for states
enum logic [2:0] {
    A, // Reset state
    B, // Initialization state
    C, // Monitoring x
    D, // Setting g
    E, // Permanent g=1
    F  // Permanent g=0
} state, next_state;

// Signals to track sequence and timing
reg [1:0] x_sequence;
reg [1:0] y_counter;

always @(*) begin
    next_state = state;
    case (state)
        A: if (~resetn) next_state = A; else next_state = B;
        B: next_state = C;
        C: begin
            case (x_sequence)
                2'b00: if (x) next_state = C;
                2'b01: if (~x) next_state = C;
                2'b10: if (x) next_state = D;
                default: next_state = C;
            endcase
        end
        D: next_state = (y || (y_counter == 2'b10))? E : (y_counter == 2'b10)? F : D;
        E: next_state = E;
        F: next_state = F;
        default: next_state = A;
    endcase
end

always @(posedge clk) begin
    if (~resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
        x_sequence <= 0;
        y_counter <= 0;
    end else begin
        state <= next_state;
        case (state)
            B: f <= 1;
            default: f <= 0;
        endcase
        case (next_state)
            D: g <= 1;
            F: g <= 0;
        endcase
        case (state)
            C: begin
                case (x_sequence)
                    2'b00: if (x) x_sequence <= 2'b01;
                    2'b01: if (~x) x_sequence <= 2'b10;
                    2'b10: if (x) x_sequence <= 2'b11;
                    default: x_sequence <= x_sequence;
                endcase
            end
            D: begin
                if (~y) y_counter <= y_counter + 1'b1;
                else y_counter <= 0;
            end
            default: begin
                x_sequence <= 0;
                y_counter <= 0;
            end
        endcase
    end
end

endmodule