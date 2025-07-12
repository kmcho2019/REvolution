module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Enumerated type for states
enum logic [2:0] {
    A,        // Initial state
    SET_F,    // State to set f to 1
    MON_X1,   // Monitor x for 1
    MON_X2,   // Monitor x for 0 after 1
    MON_X3,   // Monitor x for 1 after 0
    MON_Y1,   // Monitor y for 1 after g set
    MON_Y2,   // Monitor y for 1 in second cycle
    G_HIGH,   // State where g is permanently 1
    G_LOW     // State where g is permanently 0
} state, next_state;

// Counter for y monitoring
reg [1:0] y_count;

always @(*) begin
    next_state = state;
    case (state)
        A: begin
            if (!resetn) next_state = A;
            else next_state = SET_F;
        end
        SET_F: next_state = MON_X1;
        MON_X1: begin
            if (x) next_state = MON_X2;
            else next_state = MON_X1;
        end
        MON_X2: begin
            if (!x) next_state = MON_X3;
            else next_state = MON_X1;
        end
        MON_X3: begin
            if (x) next_state = MON_Y1;
            else next_state = MON_X1;
        end
        MON_Y1: begin
            if (y) next_state = G_HIGH;
            else next_state = MON_Y2;
        end
        MON_Y2: begin
            if (y) next_state = G_HIGH;
            else next_state = G_LOW;
        end
        G_HIGH: next_state = G_HIGH;
        G_LOW: next_state = G_LOW;
    endcase
end

always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
        y_count <= 0;
    end else begin
        state <= next_state;
        case (state)
            SET_F: f <= 1;
            default: f <= 0;
        endcase
        case (state)
            MON_Y1, MON_Y2: begin
                if (state == MON_Y1) y_count <= 1;
                else if (y_count == 1) y_count <= 2;
            end
            G_HIGH: g <= 1;
            G_LOW: g <= 0;
            default: g <= 0;
        endcase
    end
end

endmodule