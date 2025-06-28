module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

// State Enum
typedef enum logic [1:0] {
    A,
    B,
    C
} state_type;

// State and Output Registers
reg state_reg, next_state_reg;
reg f_reg, g_reg;

// Mealy State Machine Logic
always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        state_reg <= A;
        f_reg <= 0;
        g_reg <= 0;
    end
    else begin
        state_reg <= next_state_reg;
        case (state_reg)
            A: begin
                f_reg <= 1;
                next_state_reg = B;
            end
            B: begin
                if (x == 1 && x_history[1] == 0 && x_history[0] == 1)
                    next_state_reg = C;
                else
                    next_state_reg = B;
            end
            C: begin
                if (y) begin
                    g_reg <= 1;
                end
                else if (y_counter < 2) begin
                    y_counter <= y_counter + 1;
                end
                else begin
                    g_reg <= 0;
                end
                next_state_reg = C;
            end
        endcase
    end
end

// Register for x history
reg [1:0] x_history = 2'b00;

// Counter for y input
reg [1:0] y_counter = 2'b00;

// Output assignments
assign f = f_reg;
assign g = g_reg;

endmodule