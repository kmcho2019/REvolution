module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// Enum for states
enum logic [1:0] {A, B, C, D} state, next_state;

// Counter for monitoring x sequence and y timeout
logic [1:0] x_counter;
logic [1:0] y_counter;

// Output f and g
logic f_next;
logic g_next;

// State machine
always_ff @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
        x_counter <= 0;
        y_counter <= 0;
    end else begin
        state <= next_state;
        f <= f_next;
        g <= g_next;
        x_counter <= (state == C) ? x_counter + 1 : 0;
        y_counter <= (state == D) ? y_counter + 1 : 0;
    end
end

// Next state and output logic
always_comb begin
    next_state = state;
    f_next = f;
    g_next = g;
    
    case (state)
        A: begin
            if (resetn) begin
                next_state = B;
                f_next = 1;
            end
        end
        B: begin
            next_state = C;
            f_next = 0;
        end
        C: begin
            if (x_counter == 3) begin
                if (x == 1 && x_counter[0] == 1'b0) begin
                    x_counter = x_counter + 1;
                end else if (x == 0 && x_counter[0] == 1'b1) begin
                    x_counter = x_counter + 1;
                end else if (x == 1 && x_counter[1] == 1'b1) begin
                    x_counter = x_counter + 1;
                end else begin
                    x_counter = 1;
                end
                
                if (x_counter == 4) begin
                    next_state = D;
                    g_next = 1;
                end
            end else if (x_counter == 1 && x == 1) begin
                x_counter = x_counter + 1;
            end else if (x_counter == 2 && x == 0) begin
                x_counter = x_counter + 1;
            end else if (x_counter == 0 && x == 1) begin
                x_counter = x_counter + 1;
            end
        end
        D: begin
            if (y_counter > 2) begin
                g_next = 0;
            end else if (y) begin
                g_next = 1;
            end
        end
    endcase
end

endmodule