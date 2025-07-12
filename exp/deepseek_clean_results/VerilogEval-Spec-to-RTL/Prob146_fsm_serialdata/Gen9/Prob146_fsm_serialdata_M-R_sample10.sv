module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // FSM states - simplified 2-bit encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;

    reg [1:0] state, next_state;
    reg [7:0] shift_reg;
    reg shift_enable;

    // Combinational done signal
    assign done = (state == STOP) && in;

    // State transition and data processing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 0;
            out_byte <= 0;
            shift_enable <= 0;
        end else begin
            state <= next_state;
            
            if (shift_enable)
                shift_reg <= {in, shift_reg[7:1]};  // Right-shift with enable
            
            if (done)
                out_byte <= shift_reg;  // Capture output only when done
        end
    end

    // Next state and control logic
    always @(*) begin
        case (state)
            IDLE: begin
                shift_enable = 0;
                next_state = (in == 0) ? RECEIVE : IDLE;
            end
            
            RECEIVE: begin
                shift_enable = 1;
                // Transition after 8 bits (7 shifts + initial capture)
                next_state = (shift_reg[0] !== 1'bx) ? STOP : RECEIVE;
            end
            
            STOP: begin
                shift_enable = 0;
                next_state = (in == 1) ? IDLE : STOP;
            end
            
            default: next_state = IDLE;
        endcase
    end

endmodule