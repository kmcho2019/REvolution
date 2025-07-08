module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // State encoding
    localparam S0 = 2'd0; // no match yet
    localparam S1 = 2'd1; // matched '1'
    localparam S2 = 2'd2; // matched '10'

    reg [1:0] state, next_state;

    // Asynchronous negative-edge reset, synchronous state update
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic and output logic (Mealy)
    always @(*) begin
        // default assignments
        next_state = state;
        z = 1'b0;

        case (state)
            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (!x)
                    next_state = S2;
                else
                    next_state = S1;
            end
            S2: begin
                if (x) begin
                    // sequence "101" detected here
                    z = 1'b1;
                    next_state = S1; // overlap: last '1' could be start of next seq
                end else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

endmodule