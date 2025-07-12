module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

// Define the states
enum {A, B, C, D} state;

// Define the counter for x sequence
reg [1:0] x_counter;

// Define the timer for y input
reg [1:0] y_timer;

// Initialize the FSM
initial state = A;

// Initialize the counter and timer
initial x_counter = 0;
initial y_timer = 0;

// Initialize the outputs
initial f = 0;
initial g = 0;

// FSM logic
always @(posedge clk) begin
    if (~resetn) begin
        state <= A;
        x_counter <= 0;
        y_timer <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            A: begin
                if (resetn) begin
                    state <= B;
                    f <= 1;
                end
            end
            B: begin
                state <= C;
                f <= 0;
            end
            C: begin
                if (x == 1 && x_counter == 0) begin
                    x_counter <= x_counter + 1;
                end else if (x == 0 && x_counter == 1) begin
                    x_counter <= x_counter + 1;
                end else if (x == 1 && x_counter == 2) begin
                    state <= D;
                    g <= 1;
                    x_counter <= 0;
                end else if (x_counter != 0) begin
                    x_counter <= 0;
                end
            end
            D: begin
                if (y == 1) begin
                    y_timer <= 2;
                end else if (y_timer < 2) begin
                    y_timer <= y_timer + 1;
                end
                if (y_timer == 2 && y == 0) begin
                    g <= 0;
                end
            end
        endcase
    end
end

endmodule