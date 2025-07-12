module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
localparam S_RESET    = 3'b000;
localparam S_PULSE_F  = 3'b001;
localparam S_WAIT_X   = 3'b010;
localparam S_PULSE_G  = 3'b011;
localparam S_WAIT_Y   = 3'b100;
localparam S_G_HIGH   = 3'b101;
localparam S_G_LOW    = 3'b110;

reg [2:0] state, next_state;
reg [1:0] x_shift;
reg [1:0] timeout_count;

// Pattern detection shift register
always @(posedge clk) begin
    if (!resetn) begin
        x_shift <= 2'b00;
    end else begin
        x_shift <= {x_shift[0], x};
    end
end

// Timeout counter
always @(posedge clk) begin
    if (!resetn || state != S_WAIT_Y) begin
        timeout_count <= 2'b00;
    end else begin
        timeout_count <= timeout_count + 1;
    end
end

// State transition
always @(posedge clk) begin
    if (!resetn) begin
        state <= S_RESET;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        S_RESET:    next_state = resetn ? S_PULSE_F : S_RESET;
        S_PULSE_F:   next_state = S_WAIT_X;
        S_WAIT_X:    next_state = (x_shift == 2'b01 && x == 1'b1) ? S_PULSE_G : S_WAIT_X;
        S_PULSE_G:   next_state = S_WAIT_Y;
        S_WAIT_Y:    begin
            if (y) begin
                next_state = S_G_HIGH;
            end else if (timeout_count == 2'b01) begin
                next_state = S_G_LOW;
            end else begin
                next_state = S_WAIT_Y;
            end
        end
        S_G_HIGH:    next_state = S_G_HIGH;
        S_G_LOW:     next_state = S_G_LOW;
        default:     next_state = S_RESET;
    endcase
end

// Output logic
always @(posedge clk) begin
    if (!resetn) begin
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        // f output pulses high for one cycle after reset
        f <= (state == S_RESET && next_state == S_PULSE_F);
        
        // g output logic
        case (next_state)
            S_PULSE_G:   g <= 1'b1;
            S_G_HIGH:    g <= 1'b1;
            S_G_LOW:    g <= 1'b0;
            default:     g <= g; // maintain current value
        endcase
    end
end

endmodule