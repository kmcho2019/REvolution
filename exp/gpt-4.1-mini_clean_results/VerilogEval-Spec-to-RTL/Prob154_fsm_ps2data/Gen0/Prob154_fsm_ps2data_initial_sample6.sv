module TopModule(
    input        clk,
    input        reset,  // synchronous active high
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);
    // FSM states
    typedef enum reg [1:0] {
        IDLE  = 2'd0,
        BYTE1 = 2'd1,
        BYTE2 = 2'd2
    } state_t;

    state_t state, next_state;

    reg [7:0] byte1, byte2, byte3;

    // State and data registers update
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
            done  <= 1'b0; // default done low, set later if needed
            case(state)
                IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;
                    end
                end
                BYTE1: begin
                    byte2 <= in;
                end
                BYTE2: begin
                    byte3 <= in;
                    // On next cycle done will be asserted and out_bytes set
                end
            endcase

            // assert done and set out_bytes after receiving byte3
            if (state == BYTE2) begin
                out_bytes <= {byte1, byte2, in};
                done      <= 1'b1;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:
                if (in[3]) next_state = BYTE1;
                else       next_state = IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule