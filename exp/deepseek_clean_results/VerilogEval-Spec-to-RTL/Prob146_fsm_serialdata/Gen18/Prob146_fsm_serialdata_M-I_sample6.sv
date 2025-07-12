module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // One-hot encoded FSM states
    localparam IDLE    = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    localparam ERROR   = 4'b1000;

    reg [3:0] state, next_state;
    reg [7:0] shift_reg;
    reg receive_enable;
    reg stop_valid;

    // FSM state transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
            receive_enable <= 0;
            stop_valid <= 0;
        end else begin
            state <= next_state;
            
            // Shift register only updates when enabled
            if (receive_enable) begin
                shift_reg <= {in, shift_reg[7:1]};  // LSB first
            end

            // Done signal generation
            done <= stop_valid & (state == STOP);
            
            // Capture output byte when stop is valid
            if (stop_valid & (state == STOP)) begin
                out_byte <= shift_reg;
            end
        end
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                receive_enable = 0;
                stop_valid = 0;
                next_state = (in == 0) ? RECEIVE : IDLE;
            end
            
            RECEIVE: begin
                receive_enable = 1;
                stop_valid = 0;
                // Transition when 8 bits received (detected by shift_reg[0] being the last bit)
                next_state = (shift_reg[0] != 1'bX) ? STOP : RECEIVE;
            end
            
            STOP: begin
                receive_enable = 0;
                stop_valid = (in == 1);
                next_state = (in == 1) ? IDLE : ERROR;
            end
            
            ERROR: begin
                receive_enable = 0;
                stop_valid = (in == 1);
                next_state = (in == 1) ? IDLE : ERROR;
            end
            
            default: begin
                receive_enable = 0;
                stop_valid = 0;
                next_state = IDLE;
            end
        endcase
    end

endmodule