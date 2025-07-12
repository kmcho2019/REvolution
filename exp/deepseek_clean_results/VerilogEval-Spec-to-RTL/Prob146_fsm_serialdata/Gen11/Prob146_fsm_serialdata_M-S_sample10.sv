module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states
    localparam IDLE   = 1'b0;
    localparam RECEIVE = 1'b1;

    reg state, next_state;
    reg [7:0] shift_reg;

    // Combinational outputs
    always @(*) begin
        done = (state == IDLE) && (in == 1'b1) && (shift_reg != 0);
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 0;
            out_byte <= 0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    if (in == 0) begin
                        shift_reg <= 0;  // Prepare for new byte
                    end else if (done) begin
                        out_byte <= shift_reg;
                        shift_reg <= 0;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // Right shift (LSB first)
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE:   next_state = (in == 1'b0) ? RECEIVE : IDLE;
            RECEIVE: next_state = (&shift_reg) ? IDLE : RECEIVE;  // When all bits received
            default: next_state = IDLE;
        endcase
    end

endmodule