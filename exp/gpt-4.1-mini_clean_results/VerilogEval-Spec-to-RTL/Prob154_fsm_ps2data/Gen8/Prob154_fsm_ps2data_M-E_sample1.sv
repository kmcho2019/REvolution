module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    typedef enum logic [1:0] {IDLE=2'b00, BYTE2=2'b01, BYTE3=2'b10, DONE=2'b11} state_t;
    state_t state, next_state;

    reg [7:0] byte1, byte2, byte3;

    // State transition logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE:   if(in[3]) next_state = BYTE2;
            BYTE2:  next_state = BYTE3;
            BYTE3:  next_state = DONE;
            DONE:   next_state = IDLE;
        endcase
    end

    // Sequential state update and data capture
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            byte1     <= 8'd0;
            byte2     <= 8'd0;
            byte3     <= 8'd0;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // Default done deassert

            case(state)
                IDLE: begin
                    if(in[3]) 
                        byte1 <= in;
                end
                BYTE2: begin
                    byte2 <= in;
                end
                BYTE3: begin
                    byte3 <= in;
                end
                DONE: begin
                    out_bytes <= {byte1, byte2, byte3};
                    done      <= 1'b1;
                end
            endcase
        end
    end

endmodule