module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg   done
);

    // FSM states
    typedef enum reg [1:0] {IDLE = 2'd0, BYTE1 = 2'd1, BYTE2 = 2'd2} state_t;
    reg [1:0] state, next_state;

    reg [7:0] byte1, byte2, byte3;

    // FSM state transitions and output logic
    always @(*) begin
        done = 1'b0;
        next_state = state;
        case (state)
            IDLE: begin
                if (in[3]) 
                    next_state = BYTE1;
            end
            BYTE1: begin
                next_state = BYTE2;
            end
            BYTE2: begin
                next_state = IDLE;
                done = 1'b1;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state and data registers update on posedge clk
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            byte1     <= 8'd0;
            byte2     <= 8'd0;
            byte3     <= 8'd0;
            out_bytes <= 24'd0;
            done      <= 1'b0;  // Although done is combinational, also clear here for safety
        end else begin
            state <= next_state;
            case (state)
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
                    // When done is asserted, update output bytes
                    out_bytes <= {byte1, byte2, in};
                end
            endcase
        end
    end

endmodule