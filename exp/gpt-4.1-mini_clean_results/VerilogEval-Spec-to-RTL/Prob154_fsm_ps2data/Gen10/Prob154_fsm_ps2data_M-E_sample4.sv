module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // One-hot FSM states
    localparam IDLE      = 4'b0001;
    localparam GOT_BYTE1 = 4'b0010;
    localparam GOT_BYTE2 = 4'b0100;
    localparam DONE      = 4'b1000;

    reg [3:0] state, next_state;

    reg [7:0] byte1, byte2, byte3;

    // FSM sequential logic with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Load bytes in respective states
            case (state)
                IDLE: if (in[3]) byte1 <= in;
                GOT_BYTE1: byte2 <= in;
                GOT_BYTE2: byte3 <= in;
                DONE: begin
                    // Output assembled message and assert done for 1 cycle
                    out_bytes <= {byte1, byte2, byte3};
                    done <= 1'b1;
                end
                default: ;
            endcase

            // Clear done except in DONE state
            if (state != DONE)
                done <= 1'b0;
        end
    end

    // FSM combinational next state logic
    always @(*) begin
        case (state)
            IDLE:
                if (in[3])
                    next_state = GOT_BYTE1;
                else
                    next_state = IDLE;
            GOT_BYTE1: next_state = GOT_BYTE2;
            GOT_BYTE2: next_state = DONE;
            DONE:      next_state = IDLE;
            default:   next_state = IDLE;
        endcase
    end

endmodule