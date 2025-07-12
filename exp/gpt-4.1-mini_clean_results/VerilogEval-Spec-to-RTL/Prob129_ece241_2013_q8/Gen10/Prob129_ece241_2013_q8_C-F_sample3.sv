module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding for 3 states using localparam (2 bits)
    localparam S0 = 2'd0; // No match yet
    localparam S1 = 2'd1; // Matched '1'
    localparam S2 = 2'd2; // Matched '10'

    reg [1:0] state, next_state;

    // Sequential logic: state register with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational logic: next state and Mealy output computation
    always @(*) begin
        next_state = state; // default to current state
        z = 1'b0;           // default output

        case(state)
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
                    z = 1'b1; // sequence "101" detected here (Mealy output)
                end else
                    next_state = S0;
            end

            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

endmodule