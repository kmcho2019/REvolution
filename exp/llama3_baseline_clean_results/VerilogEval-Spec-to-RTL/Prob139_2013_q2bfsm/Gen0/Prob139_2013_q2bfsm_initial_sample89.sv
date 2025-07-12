`timescale 1ns/1ps

module TopModule(
    input           clk,
    input           resetn,
    input           x,
    input           y,
    output          f,
    output          g
);

typedef enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100, // g=1 permanently
    F = 3'b101  // g=0 permanently
} state_type;

state_type current_state, next_state;
logic [1:0] sequence_counter;
logic [1:0] y_counter;
logic f_next, g_next;

always_comb begin
    // Default values
    f_next = 0;
    g_next = 0;
    next_state = current_state;

    case (current_state)
        A: begin
            if (!resetn) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        B: begin
            f_next = 1;
            next_state = C;
        end
        C: begin
            if (sequence_counter == 2'b11) begin // 1, 0, 1 sequence detected
                next_state = D;
            end else if (x) begin // sequence: 1
                sequence_counter = 2'b01;
                next_state = C;
            end else if (sequence_counter == 2'b01) begin // sequence: 1, 0
                sequence_counter = 2'b11;
                next_state = C;
            end else if (sequence_counter == 2'b11) begin // already detected 1, 0, 1
                next_state = C;
            end else begin
                sequence_counter = 2'b00; // reset sequence counter if not 1
                next_state = C;
            end
        end
        D: begin
            if (y_counter < 2) begin
                if (y) begin
                    next_state = E; // y detected within two cycles, g=1 permanently
                end else begin
                    y_counter = y_counter + 1;
                    next_state = D;
                end
            end else begin
                next_state = F; // y not detected within two cycles, g=0 permanently
            end
        end
        E: begin
            g_next = 1; // maintain g=1 permanently
            next_state = E;
        end
        F: begin
            next_state = F; // maintain g=0 permanently
        end
        default: next_state = A;
    endcase
end

always_ff @(posedge clk) begin
    if (!resetn) begin
        current_state <= A;
        sequence_counter <= 0;
        y_counter <= 0;
    end else begin
        current_state <= next_state;
        if (next_state == C && x) begin
            sequence_counter <= sequence_counter + 1;
        end else if (next_state == D) begin
            y_counter <= y_counter + 1;
        end else begin
            sequence_counter <= 0;
            y_counter <= 0;
        end
    end
end

assign f = (current_state == B) ? 1 : 0;
assign g = (current_state == E) ? 1 : 0;

endmodule