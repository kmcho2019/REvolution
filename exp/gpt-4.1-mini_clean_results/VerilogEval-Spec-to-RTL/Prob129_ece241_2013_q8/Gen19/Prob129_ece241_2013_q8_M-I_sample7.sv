module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output reg z
);

    // State encoding: 3 states
    localparam S0 = 2'b00; // no match
    localparam S1 = 2'b01; // matched '1'
    localparam S2 = 2'b10; // matched "10"

    reg [1:0] state, next_state;

    // Combined next-state and output logic for optimization
    always @(*) begin
        // Default assignments to avoid latches
        next_state = S0;
        z = 1'b0;

        case (state)
            S0: begin
                if (x) 
                    next_state = S1;
                else 
                    next_state = S0;
                // output z=0 in S0
            end

            S1: begin
                if (x) 
                    next_state = S1;
                else 
                    next_state = S2;
                // output z=0 in S1
            end

            S2: begin
                if (x) begin
                    next_state = S1;
                    z = 1'b1;  // sequence "101" detected here (Mealy output)
                end
                else begin
                    next_state = S0;
                    z = 1'b0;
                end
            end

            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

endmodule