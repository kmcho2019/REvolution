module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// Define states
parameter A = 4'd0;
parameter B = 4'd1;
parameter C = 4'd2;
parameter D = 4'd3;
parameter E = 4'd4;
parameter F = 4'd5;

// State register
reg [3:0] state;
reg [3:0] nextState;

// Counters for x and y
reg [1:0] xCounter;
reg [1:0] yCounter;

// Previous values of x
reg prev_x;
reg prev_prev_x;

// Initialize state and counters
initial begin
    state = A;
    xCounter = 0;
    yCounter = 0;
    prev_x = 0;
    prev_prev_x = 0;
end

// Next state logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
        xCounter <= 0;
        yCounter <= 0;
        prev_x <= 0;
        prev_prev_x <= 0;
    end else begin
        case (state)
            A: begin
                state <= B;
                f <= 1;
                g <= 0;
            end
            B: begin
                state <= C;
                f <= 0;
            end
            C: begin
                prev_prev_x <= prev_x;
                prev_x <= x;
                if (prev_prev_x == 1 && prev_x == 0 && x == 1) begin
                    state <= D;
                    g <= 1;
                    yCounter <= 0;
                end
            end
            D: begin
                yCounter <= yCounter + 1;
                if (y == 1 || yCounter == 2) begin
                    if (y == 1) begin
                        state <= E;
                    end else begin
                        state <= F;
                        g <= 0;
                    end
                end
            end
            E: begin
                // Do nothing
            end
            F: begin
                // Do nothing
            end
            default: begin
                state <= A;
            end
        endcase
    end
end

endmodule