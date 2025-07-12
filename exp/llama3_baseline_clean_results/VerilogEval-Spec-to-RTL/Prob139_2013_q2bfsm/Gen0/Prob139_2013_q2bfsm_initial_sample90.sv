module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define states
enum {A, B, C, D, E} state, nextState;

reg [1:0] x_sequence_counter;
reg [1:0] y_wait_counter;

always @(*) begin
    case(state)
        A: begin
            if (!resetn) begin
                nextState = A;
            end else begin
                nextState = B;
            end
        end
        B: begin
            nextState = C;
        end
        C: begin
            if (x_sequence_counter == 3'b011) begin
                nextState = D;
            end else begin
                nextState = C;
            end
        end
        D: begin
            if (y_wait_counter == 2'b11 && !y) begin
                nextState = E;
            end else if (y) begin
                nextState = D;
            end else begin
                nextState = D;
            end
        end
        E: begin
            nextState = E;
        end
    endcase
end

always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        x_sequence_counter <= 0;
        y_wait_counter <= 0;
        f <= 0;
        g <= 0;
    end else begin
        state <= nextState;
        case(state)
            B: f <= 1;
            C: begin
                f <= 0;
                if (x_sequence_counter == 3'b000 && x) x_sequence_counter <= x_sequence_counter + 1;
                else if (x_sequence_counter == 3'b001 && !x) x_sequence_counter <= x_sequence_counter + 1;
                else if (x_sequence_counter == 3'b010 && x) x_sequence_counter <= x_sequence_counter + 1;
                else x_sequence_counter <= 0;
            end
            D: begin
                f <= 0;
                g <= 1;
                y_wait_counter <= y_wait_counter + 1;
                if (y) y_wait_counter <= 0;
            end
            E: begin
                f <= 0;
                g <= 0;
            end
            default: begin
                f <= 0;
                g <= 0;
            end
        endcase
    end
end

endmodule