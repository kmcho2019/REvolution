module TopModule(
    input  wire clk,
    input  wire aresetn,
    input  wire x,
    output reg  z
);

    // One-hot encoded states
    localparam [2:0]
        S0 = 3'b001, // no match
        S1 = 3'b010, // matched '1'
        S2 = 3'b100; // matched '10'

    reg [2:0] state, next_state;

    // Combinational logic: next state and Mealy output
    always @(*) begin
        // Default assignments
        next_state = S0;
        z = 1'b0;

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
                    z = 1'b1;       // "101" detected
                    next_state = S1; // Potential start of next sequence
                end else
                    next_state = S0;
            end
            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

    // Sequential logic with asynchronous active-low reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

endmodule