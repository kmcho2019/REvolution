module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // One-hot state encoding
    localparam [3:0] NO_GRANT  = 4'b0001,  // State A
                     GRANT0    = 4'b0010,  // State B
                     GRANT1    = 4'b0100,  // State C
                     GRANT2    = 4'b1000;  // State D

    reg [3:0] state, next_state;
    
    // Optimized priority encoder (evaluated only when needed)
    wire [1:0] priority_request;
    assign priority_request = (state == NO_GRANT) ? 
                            (r[0] ? 2'b01 :   // Device 0 highest priority
                             r[1] ? 2'b10 :   // Device 1
                             r[2] ? 2'b11 :   // Device 2
                                    2'b00) :  // No request
                            2'b00;           // Don't care when not in NO_GRANT

    // State register
    always @(posedge clk) begin
        if (!resetn) begin
            state <= NO_GRANT;
            g <= 3'b000;
        end
        else begin
            state <= next_state;
            // Registered outputs
            g <= {state[3], state[2], state[1]};  // Direct one-hot to output mapping
        end
    end

    // Next state logic - simplified with one-hot
    always @(*) begin
        next_state = NO_GRANT;  // Default
        case (1'b1)  // Synthesis will optimize this to parallel case
            state[0]: begin  // NO_GRANT
                case (priority_request)
                    2'b01: next_state = GRANT0;
                    2'b10: next_state = GRANT1;
                    2'b11: next_state = GRANT2;
                    default: next_state = NO_GRANT;
                endcase
            end
            state[1]: next_state = r[0] ? GRANT0 : NO_GRANT;  // GRANT0
            state[2]: next_state = r[1] ? GRANT1 : NO_GRANT;   // GRANT1
            state[3]: next_state = r[2] ? GRANT2 : NO_GRANT;   // GRANT2
        endcase
    end

endmodule