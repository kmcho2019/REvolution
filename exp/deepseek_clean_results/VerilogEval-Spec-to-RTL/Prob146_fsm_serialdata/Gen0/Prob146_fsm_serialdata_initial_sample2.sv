module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states
    localparam IDLE   = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP   = 2'b10;
    localparam ERROR  = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // FSM state transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    done <= 0;
                    bit_count <= 0;
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // Shift right (LSB first)
                    bit_count <= bit_count + 1;
                end
                
                STOP: begin
                    out_byte <= shift_reg;
                    done <= 1;
                end
                
                ERROR: begin
                    done <= 0;
                end
            endcase
        end
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 0) ? RECEIVE : IDLE;
            end
            
            RECEIVE: begin
                if (bit_count == 7) begin
                    next_state = STOP;
                end else begin
                    next_state = RECEIVE;
                end
            end
            
            STOP: begin
                if (in == 1) begin
                    next_state = IDLE;
                end else begin
                    next_state = ERROR;
                end
            end
            
            ERROR: begin
                next_state = (in == 1) ? IDLE : ERROR;
            end
            
            default: next_state = IDLE;
        endcase
    end

endmodule