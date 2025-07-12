module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// Define the states of the FSM
parameter STATE_A = 3'b000;
parameter STATE_B = 3'b001;
parameter STATE_C = 3'b010;
parameter STATE_D = 3'b011;
parameter STATE_E = 3'b100;
parameter STATE_F = 3'b101;

// Declare the state variable
reg [2:0] state;
reg [2:0] next_state;

// Declare the output variables
reg f_reg;
reg g_reg;

// Define the next state logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
    end else begin
        state <= next_state;
    end
end

// Define the combinational logic for the next state
always @(*) begin
    case (state)
        STATE_A: begin
            if (resetn) begin
                next_state = STATE_B;
            end else begin
                next_state = STATE_A;
            end
        end
        STATE_B: begin
            next_state = STATE_C;
        end
        STATE_C: begin
            reg [1:0] x_count;
            always @(posedge clk) begin
                if (state == STATE_C) begin
                    if (x == 1'b1) begin
                        x_count <= x_count + 1;
                    end else begin
                        x_count <= 0;
                    end
                end
            end
            if (x_count == 2'b11) begin
                next_state = STATE_D;
            end else begin
                next_state = STATE_C;
            end
        end
        STATE_D: begin
            reg [1:0] y_count;
            always @(posedge clk) begin
                if (state == STATE_D) begin
                    if (y == 1'b1) begin
                        y_count <= 2'b10;
                    end else begin
                        y_count <= y_count + 1;
                    end
                end
            end
            if (y_count == 2'b10) begin
                next_state = STATE_E;
            end else if (y_count == 2'b11) begin
                next_state = STATE_F;
            end else begin
                next_state = STATE_D;
            end
        end
        STATE_E: begin
            next_state = STATE_E;
        end
        STATE_F: begin
            next_state = STATE_F;
        end
        default: begin
            next_state = STATE_A;
        end
    endcase
end

// Define the output logic
always @(posedge clk) begin
    case (state)
        STATE_B: begin
            f_reg <= 1'b1;
            g_reg <= 1'b0;
        end
        STATE_E: begin
            f_reg <= 1'b0;
            g_reg <= 1'b1;
        end
        STATE_F: begin
            f_reg <= 1'b0;
            g_reg <= 1'b0;
        end
        default: begin
            f_reg <= 1'b0;
            g_reg <= 1'b0;
        end
    endcase
end

assign f = f_reg;
assign g = g_reg;

endmodule