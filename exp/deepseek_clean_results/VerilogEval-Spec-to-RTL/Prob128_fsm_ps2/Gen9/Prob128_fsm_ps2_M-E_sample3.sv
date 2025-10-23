module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // Message storage (3 bytes)
    reg [7:0] msg [0:2];
    
    // FSM states
    typedef enum logic [1:0] {
        SEARCH,
        BYTE1,
        BYTE2,
        BYTE3
    } state_t;
    
    state_t curr_state, next_state;
    
    always @(posedge clk) begin
        if (reset) begin
            curr_state <= SEARCH;
            done <= 1'b0;
        end else begin
            curr_state <= next_state;
            
            // Store incoming bytes in appropriate position
            case (curr_state)
                SEARCH: if (in[3]) msg[0] <= in;
                BYTE1:  msg[1] <= in;
                BYTE2:  msg[2] <= in;
                default: ; // No storage in BYTE3 state
            endcase
            
            // Done is asserted only in cycle after third byte
            done <= (curr_state == BYTE2);
        end
    end
    
    // Next state logic
    always @(*) begin
        case (curr_state)
            SEARCH: next_state = in[3] ? BYTE1 : SEARCH;
            BYTE1:  next_state = BYTE2;
            BYTE2:  next_state = (in[3]) ? BYTE1 : BYTE3;  // Early start of new message?
            BYTE3:  next_state = in[3] ? BYTE1 : SEARCH;
            default: next_state = SEARCH;
        endcase
    end

endmodule