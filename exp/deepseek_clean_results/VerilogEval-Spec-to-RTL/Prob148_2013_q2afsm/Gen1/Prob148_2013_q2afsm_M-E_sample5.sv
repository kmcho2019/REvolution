module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding
    localparam [1:0] NO_GRANT  = 2'b00,  // State A
                     GRANT0    = 2'b01,  // State B
                     GRANT1    = 2'b10,  // State C
                     GRANT2    = 2'b11;  // State D

    reg [1:0] state, next_state;
    
    // Priority encoder for new requests
    wire [1:0] priority_request;
    assign priority_request = r[0] ? 2'b01 :   // Device 0 highest priority
                             r[1] ? 2'b10 :   // Device 1
                             r[2] ? 2'b11 :   // Device 2
                                    2'b00;    // No request

    // State register
    always @(posedge clk) begin
        if (!resetn)
            state <= NO_GRANT;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            NO_GRANT: begin
                // Grant to highest priority requester
                next_state = priority_request;
            end
            GRANT0: begin
                // Keep grant if device 0 still requesting
                next_state = r[0] ? GRANT0 : NO_GRANT;
            end
            GRANT1: begin
                // Keep grant if device 1 still requesting
                next_state = r[1] ? GRANT1 : NO_GRANT;
            end
            GRANT2: begin
                // Keep grant if device 2 still requesting
                next_state = r[2] ? GRANT2 : NO_GRANT;
            end
            default: next_state = NO_GRANT;
        endcase
    end

    // Output logic - simple decode of current state
    assign g[0] = (state == GRANT0);
    assign g[1] = (state == GRANT1);
    assign g[2] = (state == GRANT2);

endmodule