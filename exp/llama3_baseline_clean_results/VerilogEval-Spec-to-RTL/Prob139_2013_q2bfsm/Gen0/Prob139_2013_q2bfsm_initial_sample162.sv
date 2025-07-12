module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// Define states
parameter A = 4'b0000;
parameter B = 4'b0001;
parameter C = 4'b0010;
parameter D = 4'b0011;
parameter E = 4'b0100;
parameter F = 4'b0101;

// Current state and next state
reg [3:0] current_state;
reg [3:0] next_state;

// Internal signals
reg f_reg;
reg g_reg;
reg x_prev;
reg x_prev_prev;
reg y_count;

// FSM state transitions
always @(*) begin
    case (current_state)
        A: begin
            if (!resetn) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        B: begin
            next_state = C;
        end
        C: begin
            if (x_prev_prev == 1 && x_prev == 0 && x == 1) begin
                next_state = D;
            end else begin
                next_state = C;
            end
            x_prev_prev <= x_prev;
            x_prev <= x;
        end
        D: begin
            if (y_count == 2) begin
                if (y == 1) begin
                    next_state = E;
                end else begin
                    next_state = F;
                end
            end else begin
                next_state = D;
                if (y == 1) begin
                    y_count <= 2;
                end else begin
                    y_count <= y_count + 1;
                end
            end
        end
        E: begin
            next_state = E;
        end
        F: begin
            next_state = F;
        end
        default: next_state = A;
    endcase
end

// Output logic
always @(*) begin
    case (current_state)
        A: begin
            f_reg = 0;
            g_reg = 0;
        end
        B: begin
            f_reg = 1;
            g_reg = 0;
        end
        C: begin
            f_reg = 0;
            g_reg = 0;
        end
        D: begin
            f_reg = 0;
            g_reg = 1;
        end
        E: begin
            f_reg = 0;
            g_reg = 1;
        end
        F: begin
            f_reg = 0;
            g_reg = 0;
        end
        default: begin
            f_reg = 0;
            g_reg = 0;
        end
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= A;
        x_prev <= 0;
        x_prev_prev <= 0;
        y_count <= 0;
        f_reg <= 0;
        g_reg <= 0;
    end else begin
        current_state <= next_state;
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule