module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // One-hot state encoding
    // S0 = 3'b001 (initial state)
    // S1 = 3'b010
    // S2 = 3'b100
    reg [2:0] state, next_state;

    localparam S0 = 3'b001;
    localparam S1 = 3'b010;
    localparam S2 = 3'b100;

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state and output logic (Mealy output)
    always @(*) begin
        z = 1'b0;
        next_state = S0; // default to reset state for safety

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
                    z = 1'b1; // sequence "101" detected
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