module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define states
enum logic [2:0] {A, B, C, D, E, F} state, nextState;

// Counter to keep track of clock cycles in certain states
reg [1:0] counter;

always @(*) begin
    case(state)
        A: begin
            if (~resetn) 
                nextState = A;
            else 
                nextState = B;
            f = 0;
            g = 0;
        end
        B: begin
            nextState = C;
            f = 1;
            g = 0;
        end
        C: begin
            if (x == 1 && counter == 0) begin
                counter = counter + 1;
                nextState = C;
            end else if (x == 0 && counter == 1) begin
                counter = counter + 1;
                nextState = C;
            end else if (x == 1 && counter == 2) begin
                counter = 0;
                nextState = D;
            end else begin
                counter = 0;
                nextState = C;
            end
            f = 0;
            g = 0;
        end
        D: begin
            if (y == 1 || counter == 2) begin
                if (y == 1)
                    nextState = E;
                else
                    nextState = F;
            end else begin
                counter = counter + 1;
                nextState = D;
            end
            f = 0;
            g = 1;
        end
        E: begin
            nextState = E;
            f = 0;
            g = 1;
        end
        F: begin
            nextState = F;
            f = 0;
            g = 0;
        end
        default: begin
            nextState = A;
            f = 0;
            g = 0;
        end
    endcase
end

always @(posedge clk) begin
    if (~resetn)
        state <= A;
    else
        state <= nextState;
end

endmodule