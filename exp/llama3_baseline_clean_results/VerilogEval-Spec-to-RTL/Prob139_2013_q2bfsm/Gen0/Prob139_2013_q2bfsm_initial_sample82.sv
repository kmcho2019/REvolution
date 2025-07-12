module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

// Define states
parameter STATE_A = 3'b000;
parameter STATE_F = 3'b001;
parameter STATE_X1 = 3'b010;
parameter STATE_X0 = 3'b011;
parameter STATE_X1_SEQ = 3'b100;
parameter STATE_Y_WAIT1 = 3'b101;
parameter STATE_Y_WAIT2 = 3'b110;
parameter STATE_G_ON = 3'b111;
parameter STATE_G_OFF = 3'b1000;

// Current state and next state
reg [2:0] current_state, next_state;

// Output logic
assign f = (current_state == STATE_F);
assign g = (current_state == STATE_G_ON);

// State machine
always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        current_state <= STATE_A;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        STATE_A: begin
            if (resetn) begin
                next_state = STATE_F;
            end else begin
                next_state = STATE_A;
            end
        end
        STATE_F: begin
            next_state = STATE_X1;
        end
        STATE_X1: begin
            if (x) begin
                next_state = STATE_X0;
            end else begin
                next_state = STATE_X1;
            end
        end
        STATE_X0: begin
            if (~x) begin
                next_state = STATE_X1_SEQ;
            end else begin
                next_state = STATE_X1;
            end
        end
        STATE_X1_SEQ: begin
            if (x) begin
                next_state = STATE_Y_WAIT1;
            end else begin
                next_state = STATE_X1;
            end
        end
        STATE_Y_WAIT1: begin
            if (y) begin
                next_state = STATE_G_ON;
            end else begin
                next_state = STATE_Y_WAIT2;
            end
        end
        STATE_Y_WAIT2: begin
            if (y) begin
                next_state = STATE_G_ON;
            end else begin
                next_state = STATE_G_OFF;
            end
        end
        STATE_G_ON, STATE_G_OFF: begin
            next_state = current_state; // Stay in the same state
        end
        default: begin
            next_state = STATE_A;
        end
    endcase
end

endmodule