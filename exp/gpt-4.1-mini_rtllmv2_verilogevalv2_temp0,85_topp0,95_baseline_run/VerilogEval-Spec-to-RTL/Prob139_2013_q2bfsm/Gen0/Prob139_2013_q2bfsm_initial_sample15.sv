module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
typedef enum logic [2:0] {
    A = 3'd0,  // reset state
    B = 3'd1,  // f=1 for one cycle
    C0 = 3'd2, // waiting for first '1' in pattern
    C1 = 3'd3, // saw first '1' in pattern
    C2 = 3'd4, // saw '1','0' pattern, waiting for last '1'
    D = 3'd5,  // set g=1 for one cycle
    E = 3'd6,  // monitor y for 2 cycles, g=1
    F = 3'd7   // g=0 forever
} state_t;

state_t state, next_state;

reg [1:0] y_count; // counts up to 2 cycles for y monitoring

// Sequential state and output logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        f <= 1'b0;
        g <= 1'b0;
        y_count <= 2'd0;
    end else begin
        state <= next_state;
        case (next_state)
            A: begin
                f <= 1'b0;
                g <= 1'b0;
                y_count <= 2'd0;
            end
            B: begin
                f <= 1'b1; // f=1 for one cycle here
                g <= 1'b0;
                y_count <= 2'd0;
            end
            C0, C1, C2: begin
                f <= 1'b0;
                g <= 1'b0;
                y_count <= 2'd0;
            end
            D: begin
                f <= 1'b0;
                g <= 1'b1; // g=1 for one cycle
                y_count <= 2'd0;
            end
            E: begin
                f <= 1'b0;
                g <= 1'b1; // maintain g=1
                if (y_count < 2)
                    y_count <= y_count + 1;
                // else keep at 2
            end
            F: begin
                f <= 1'b0;
                g <= 1'b0; // g=0 permanently
                y_count <= y_count; // hold
            end
            default: begin
                f <= 1'b0;
                g <= 1'b0;
                y_count <= 2'd0;
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    case (state)
        A: begin
            if (resetn)
                next_state = B;
            else
                next_state = A;
        end
        B: begin
            // After one cycle with f=1, move to sequence detection start C0
            next_state = C0;
        end
        // Sequence detector states:
        // Detect sequence 1,0,1 on input x in 3 consecutive clocks:
        // We use states C0, C1, C2 for the progress:
        // C0: waiting for first '1'
        // C1: got first '1', waiting for '0'
        // C2: got '1','0', waiting for last '1'
        C0: begin
            if (x == 1'b1)
                next_state = C1;
            else
                next_state = C0;
        end
        C1: begin
            if (x == 1'b0)
                next_state = C2;
            else if (x == 1'b1)
                next_state = C1; // stay, waiting for zero next
            else
                next_state = C0; // safety fallback
        end
        C2: begin
            if (x == 1'b1)
                next_state = D; // sequence detected
            else if (x == 1'b0)
                next_state = C0; // restart detection
            else
                next_state = C0;
        end
        D: begin
            // After one cycle with g=1, move to y monitoring E
            next_state = E;
        end
        E: begin
            if (y == 1'b1) begin
                // If y=1 anytime here, stay in E with g=1 forever
                next_state = E;
            end else if (y_count == 2) begin
                // after 2 cycles without y=1, move to F
                next_state = F;
            end else begin
                // continue monitoring y
                next_state = E;
            end
        end
        F: begin
            // g=0 forever until reset
            next_state = F;
        end
        default: next_state = A;
    endcase
end

endmodule