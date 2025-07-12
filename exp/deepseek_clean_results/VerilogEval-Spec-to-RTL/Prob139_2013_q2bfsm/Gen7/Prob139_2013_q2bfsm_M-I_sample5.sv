module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
localparam RESET            = 3'b000;
localparam INITIAL_PULSE    = 3'b001;
localparam WAIT_FOR_SEQUENCE = 3'b010;
localparam CHECK_Y         = 3'b011;
localparam LOCKED_G1       = 3'b100;
localparam LOCKED_G0       = 3'b101;

reg [2:0] state, next_state;
reg [2:0] x_shift;
reg [1:0] y_timer;

// State transition
always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        x_shift <= 3'b000;
        y_timer <= 2'b00;
    end else begin
        state <= next_state;
        x_shift <= {x_shift[1:0], x};
        
        if (state == CHECK_Y) begin
            y_timer <= y_timer + 1;
        end else begin
            y_timer <= 2'b00;
        end
    end
end

// Next state logic
always @(*) begin
    case (state)
        RESET: next_state = resetn ? INITIAL_PULSE : RESET;
        INITIAL_PULSE: next_state = WAIT_FOR_SEQUENCE;
        WAIT_FOR_SEQUENCE: 
            next_state = (x_shift == 3'b101) ? CHECK_Y : WAIT_FOR_SEQUENCE;
        CHECK_Y: 
            if (y) begin
                next_state = LOCKED_G1;
            end else if (y_timer == 2'b01) begin  // After 2 cycles
                next_state = LOCKED_G0;
            end else begin
                next_state = CHECK_Y;
            end
        LOCKED_G1: next_state = LOCKED_G1;
        LOCKED_G0: next_state = LOCKED_G0;
        default: next_state = RESET;
    endcase
end

// Output logic
always @(*) begin
    case (state)
        INITIAL_PULSE: begin
            f = 1'b1;
            g = 1'b0;
        end
        CHECK_Y: begin
            f = 1'b0;
            g = 1'b1;
        end
        LOCKED_G1: begin
            f = 1'b0;
            g = 1'b1;
        end
        LOCKED_G0: begin
            f = 1'b0;
            g = 1'b0;
        end
        default: begin
            f = 1'b0;
            g = 1'b0;
        end
    endcase
end

endmodule