module TopModule (
    input  wire clk,
    input  wire aresetn,
    input  wire x,
    output reg  z
);

    // State encoding
    typedef enum logic [1:0] {
        S0 = 2'b00, // no match
        S1 = 2'b01, // matched '1'
        S2 = 2'b10  // matched '10'
    } state_t;

    state_t state, next_state;

    // State transition logic
    always @(*) begin
        z = 1'b0; // default output
        case (state)
            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S2;
            end
            S2: begin
                if (x) begin
                    next_state = S1;
                    z = 1'b1; // sequence "101" detected when in S2 and x=1
                end else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

    // Sequential state update with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            state <= next_state;
        end
    end

endmodule