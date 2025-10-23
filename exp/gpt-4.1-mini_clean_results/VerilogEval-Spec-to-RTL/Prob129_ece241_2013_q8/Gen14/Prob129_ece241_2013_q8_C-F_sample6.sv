module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding using localparam for minimal area and synthesis friendliness
    localparam S0 = 2'd0; // no bits matched
    localparam S1 = 2'd1; // matched '1'
    localparam S2 = 2'd2; // matched "10"

    reg [1:0] state, next_state;

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Combined next state and output logic: defaults to safe values to avoid inferred latches
    always @(*) begin
        next_state = state; 
        z = 1'b0;

        case(state)
            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
                z = 1'b0;
            end
            S1: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S2;
                z = 1'b0;
            end
            S2: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
                // Mealy output: detected sequence '101' when in S2 and x=1
                z = x;
            end
            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

endmodule