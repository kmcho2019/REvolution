module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output reg z
);

    // One-hot state encoding: only one bit is high at a time
    localparam S0 = 3'b001;  // initial state, no bits matched
    localparam S1 = 3'b010;  // matched "1"
    localparam S2 = 3'b100;  // matched "10"

    reg [2:0] state, next_state;

    // Next state and output logic (Mealy)
    always @(*) begin
        // Default assignments
        next_state = 3'b000;
        z = 1'b0;

        case (state)
            S0: begin
                if (x)      next_state = S1;
                else        next_state = S0;
                z = 1'b0; // no output in initial state
            end
            S1: begin
                if (x)      next_state = S1;
                else        next_state = S2;
                z = 1'b0; // output depends on next input, not here
            end
            S2: begin
                if (x) begin
                    next_state = S1;
                    z = 1'b1;  // sequence "101" detected here (Mealy output)
                end else begin
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

    // State register with async negedge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

endmodule