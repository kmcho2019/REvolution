module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define states
enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state, next_state;

// Internal signals
reg [1:0] x_sequence;
reg [1:0] y_timeout;

always @(*) begin
    case(state)
        A: begin
            if (!resetn) begin
                next_state = A;
                f = 0;
                g = 0;
            end else begin
                next_state = B;
                f = 1;
                g = 0;
            end
        end
        B: begin
            next_state = C;
            f = 0;
            g = 0;
            x_sequence = 0;
        end
        C: begin
            if (x_sequence == 2'b101) begin // Sequence 1, 0, 1 detected
                next_state = D;
                g = 1;
                y_timeout = 0;
            end else begin
                next_state = C;
                g = 0;
                if (x) begin
                    x_sequence = {x_sequence[0], 1'b1};
                end else begin
                    x_sequence = {x_sequence[0], 1'b0};
                end
            end
            f = 0;
        end
        D: begin
            next_state = D;
            f = 0;
            if (y_timeout < 2) begin
                if (y) begin
                    // Permanent g = 1 state
                    g = 1;
                end else begin
                    y_timeout = y_timeout + 1;
                    if (y_timeout == 2) begin
                        // Permanent g = 0 state
                        g = 0;
                    end else begin
                        g = 1;
                    end
                end
            end else if (y_timeout == 2 &&!y) begin
                g = 0;
            end else begin
                g = 1; // If y was 1, g remains 1
            end
        end
        default: begin
            next_state = A;
            f = 0;
            g = 0;
        end
    endcase
end

always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule