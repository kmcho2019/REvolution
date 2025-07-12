module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

// FSM states
typedef enum reg [1:0] {
    WAIT_SYNC = 2'd0,
    BYTE2     = 2'd1,
    BYTE3     = 2'd2,
    DONE_WAIT = 2'd3
} state_t;

reg [7:0] byte1, byte2, byte3;
reg [1:0] state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= WAIT_SYNC;
        byte1 <= 8'd0;
        byte2 <= 8'd0;
        byte3 <= 8'd0;
        out_bytes <= 24'd0;
        done <= 1'b0;
    end else begin
        state <= next_state;

        case (state)
            WAIT_SYNC: begin
                done <= 1'b0;
                if (in[3]) begin
                    byte1 <= in;
                end
            end
            BYTE2: begin
                done <= 1'b0;
                byte2 <= in;
            end
            BYTE3: begin
                done <= 1'b0;
                byte3 <= in;
            end
            DONE_WAIT: begin
                done <= 1'b1;
                out_bytes <= {byte1, byte2, byte3};
            end
            default: begin
                done <= 1'b0;
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    case (state)
        WAIT_SYNC: begin
            if (in[3])
                next_state = BYTE2;
            else
                next_state = WAIT_SYNC;
        end
        BYTE2: begin
            next_state = BYTE3;
        end
        BYTE3: begin
            next_state = DONE_WAIT;
        end
        DONE_WAIT: begin
            next_state = WAIT_SYNC;
        end
        default: next_state = WAIT_SYNC;
    endcase
end

endmodule