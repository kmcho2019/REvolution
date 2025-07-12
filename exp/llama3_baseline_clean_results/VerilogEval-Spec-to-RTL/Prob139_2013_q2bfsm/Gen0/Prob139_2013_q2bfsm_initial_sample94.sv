module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define the states
enum logic [2:0] {A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101} state, next_state;

// Counter to monitor the sequence of x
reg [1:0] x_counter;

// Counter to monitor the sequence of y
reg [1:0] y_counter;

always @(*) begin
    next_state = state;
    f = 0;
    g = 0;
    case (state)
        A: begin
            if (~resetn) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        B: begin
            f = 1;
            next_state = C;
        end
        C: begin
            case (x_counter)
                2'b00: begin
                    if (x) begin
                        x_counter = 2'b01;
                    end
                end
                2'b01: begin
                    if (~x) begin
                        x_counter = 2'b10;
                    end else begin
                        x_counter = 2'b01;
                    end
                end
                2'b10: begin
                    if (x) begin
                        next_state = D;
                        x_counter = 2'b00;
                    end else begin
                        x_counter = 2'b01;
                    end
                end
            endcase
        end
        D: begin
            g = 1;
            if (y_counter == 2'b00) begin
                if (y) begin
                    next_state = E;
                end else begin
                    y_counter = y_counter + 1;
                end
            end else if (y_counter == 2'b01) begin
                if (y) begin
                    next_state = E;
                end else begin
                    next_state = F;
                end
            end
        end
        E: begin
            g = 1;
        end
        F: begin
            g = 0;
        end
    endcase
end

always @(posedge clk) begin
    if (~resetn) begin
        state <= A;
        x_counter <= 2'b00;
        y_counter <= 2'b00;
    end else begin
        state <= next_state;
    end
end

endmodule