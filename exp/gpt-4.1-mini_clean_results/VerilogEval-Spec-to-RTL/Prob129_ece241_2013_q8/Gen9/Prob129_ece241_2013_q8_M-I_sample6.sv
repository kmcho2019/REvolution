module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // One-hot state encoding for 3 states
    localparam S0 = 3'b001;  // No match yet
    localparam S1 = 3'b010;  // Matched '1'
    localparam S2 = 3'b100;  // Matched '10'

    reg [2:0] state, next_state;
    reg z_next;

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= z_next;
        end
    end

    // Next state and next output logic (Mealy FSM)
    always @(*) begin
        z_next = 1'b0;
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
                    next_state = S1;
                    z_next = 1'b1;  // Sequence "101" detected here
                end else
                    next_state = S0;
            end

            default: begin
                next_state = S0;
                z_next = 1'b0;
            end
        endcase
    end

endmodule