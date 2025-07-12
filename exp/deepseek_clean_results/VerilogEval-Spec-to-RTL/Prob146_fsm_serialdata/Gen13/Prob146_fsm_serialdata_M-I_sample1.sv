module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Binary encoded FSM states
    localparam IDLE   = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP   = 2'b10;
    localparam ERROR  = 2'b11;

    reg [1:0] state, next_state;
    reg [7:0] shift_reg;
    reg done_next;

    // State transition and data processing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            done <= done_next;
            
            case (state)
                IDLE: begin
                    if (in == 0) begin
                        shift_reg <= 0;  // Prepare for new byte
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // Right shift with new bit
                end
                
                STOP: begin
                    if (in) begin
                        out_byte <= shift_reg;  // Only update when valid stop bit
                    end
                end
            endcase
        end
    end

    // Next state and output logic
    always @(*) begin
        next_state = state;
        done_next = 0;
        
        case (state)
            IDLE: begin
                if (in == 0) begin
                    next_state = RECEIVE;
                end
            end
            
            RECEIVE: begin
                if (&shift_reg[6:0]) begin  // Check if we've received 7 bits already
                    next_state = STOP;
                end
            end
            
            STOP: begin
                if (in) begin
                    next_state = IDLE;
                    done_next = 1;  // Single-cycle pulse
                end else begin
                    next_state = ERROR;
                end
            end
            
            ERROR: begin
                if (in) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule