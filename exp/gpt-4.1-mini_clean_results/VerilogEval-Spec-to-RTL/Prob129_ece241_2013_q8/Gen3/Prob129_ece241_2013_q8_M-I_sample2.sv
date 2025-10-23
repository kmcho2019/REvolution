module TopModule (
    input  clk,
    input  aresetn,  // active low async reset
    input  x,
    output reg z
);

    // One-hot state encoding (3 states)
    localparam S0 = 3'b001; // initial state, no match
    localparam S1 = 3'b010; // matched '1'
    localparam S2 = 3'b100; // matched '10'

    reg [2:0] current_state, next_state;

    // Asynchronous negative edge reset and synchronous state update on posedge clk
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Next state and output logic (Mealy FSM)
    always @(*) begin
        // Default assignments
        next_state = current_state;
        z = 1'b0;

        case (current_state)
            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
                z = 1'b0;
            end

            S1: begin
                if (!x)
                    next_state = S2;
                else
                    next_state = S1;
                z = 1'b0;
            end

            S2: begin
                if (x) begin
                    next_state = S1; // potential start of overlapping sequence
                    z = 1'b1;        // sequence "101" detected
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

endmodule