module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // FSM States
    typedef enum reg [1:0] {
        SEARCH = 2'd0,
        BYTE1  = 2'd1,
        BYTE2  = 2'd2,
        DONE   = 2'd3
    } state_t;

    reg [7:0] byte1, byte2, byte3;
    reg [1:0] state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            SEARCH: next_state = (in[3]) ? BYTE1 : SEARCH;
            BYTE1:  next_state = BYTE2;
            BYTE2:  next_state = DONE;
            DONE:   next_state = SEARCH;
            default: next_state = SEARCH;
        endcase
    end

    // State and datapath registers
    always @(posedge clk) begin
        if (reset) begin
            state     <= SEARCH;
            byte1     <= 8'd0;
            byte2     <= 8'd0;
            byte3     <= 8'd0;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0; // default

            case(state)
                SEARCH: begin
                    if (in[3]) byte1 <= in;
                end
                BYTE1: begin
                    byte2 <= in;
                end
                BYTE2: begin
                    byte3 <= in;
                end
                DONE: begin
                    out_bytes <= {byte1, byte2, byte3};
                    done <= 1'b1;
                end
            endcase
        end
    end

endmodule