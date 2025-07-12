module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);

typedef enum {RESET, PULSE_F, DETECT_SEQ, G_HIGH} state_t;

state_t state, next_state;

reg seq_detected;
reg y_detected;

always @ (*) begin
    case (state)
        RESET: begin
            if (resetn) begin
                next_state = PULSE_F;
            end else begin
                next_state = RESET;
            end
        end
        PULSE_F: begin
            next_state = DETECT_SEQ;
        end
        DETECT_SEQ: begin
            if (seq_detected) begin
                next_state = G_HIGH;
            end else begin
                next_state = DETECT_SEQ;
            end
        end
        G_HIGH: begin
            next_state = G_HIGH;
        end
    endcase
end

always @ (posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        f <= 0;
        g <= 0;
        seq_detected <= 0;
        y_detected <= 0;
    end else begin
        state <= next_state;
        case (state)
            PULSE_F: begin
                f <= 1;
            end
            DETECT_SEQ: begin
                // Trigger sequence detection sub-FSM
                seq_detected <= detect_sequence(x);
                if (seq_detected) begin
                    g <= 0; // Reset g before setting it in G_HIGH state
                end
            end
            G_HIGH: begin
                g <= y_detected;
            end
            default: begin
                f <= 0;
            end
        endcase
    end
end

function reg detect_sequence(input x);
    reg [2:0] seq_count;
    always @ (posedge clk) begin
        if (!resetn) begin
            seq_count <= 0;
        end else if (state == DETECT_SEQ) begin
            if (x == 1 && seq_count == 0) begin
                seq_count <= 1;
            end else if (x == 0 && seq_count == 1) begin
                seq_count <= 2;
            end else if (x == 1 && seq_count == 2) begin
                seq_count <= 3;
            end else begin
                seq_count <= 0;
            end
        end
    end
    if (seq_count == 3) begin
        detect_sequence = 1;
    end else begin
        detect_sequence = 0;
    end
endfunction

always @ (posedge clk) begin
    if (!resetn) begin
        y_detected <= 0;
    end else if (state == G_HIGH) begin
        if (y) begin
            y_detected <= 1;
        end else if (y_detected == 0) begin
            // Set y_detected to 0 permanently if y is not detected within 2 cycles
            y_detected <= 0;
        end
    end
end

endmodule