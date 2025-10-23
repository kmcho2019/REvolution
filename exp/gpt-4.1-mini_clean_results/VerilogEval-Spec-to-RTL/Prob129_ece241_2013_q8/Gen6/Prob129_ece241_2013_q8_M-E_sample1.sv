module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset
    input  x,
    output reg z
);

    // State encoding
    localparam S0 = 2'b00; // No bits matched
    localparam S1 = 2'b01; // Matched '1'
    localparam S2 = 2'b10; // Matched '10'

    reg [1:0] current_state, next_state;

    // State register with negative edge asynchronous reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (current_state)
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
                if (x)
                    next_state = S1; // sequence detected, move to S1 for overlap
                else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

    // Output logic (Mealy output)
    always @(*) begin
        if (current_state == S2 && x)
            z = 1'b1;
        else
            z = 1'b0;
    end

endmodule