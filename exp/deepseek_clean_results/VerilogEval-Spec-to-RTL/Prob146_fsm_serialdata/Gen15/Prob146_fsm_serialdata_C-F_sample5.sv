module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states - optimized 2-bit encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    localparam ERROR   = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Sequential logic - optimized for power and timing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            
            // Only update registers when needed
            case (state)
                IDLE: begin
                    bit_count <= 0;
                    done <= 0;
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    if (bit_count == 7)
                        bit_count <= 0;
                    else
                        bit_count <= bit_count + 1;
                end
                
                STOP: begin
                    out_byte <= shift_reg;
                    done <= (in == 1);
                end
                
                ERROR: begin
                    // No register updates needed
                end
            endcase
        end
    end

    // Combinational next state logic - optimized for minimal transitions
    always @(*) begin
        case (state)
            IDLE:    next_state = (in == 0) ? RECEIVE : IDLE;
            RECEIVE: next_state = (bit_count == 7) ? STOP : RECEIVE;
            STOP:    next_state = (in == 1) ? IDLE : ERROR;
            ERROR:   next_state = (in == 1) ? IDLE : ERROR;
            default: next_state = IDLE;
        endcase
    end

endmodule