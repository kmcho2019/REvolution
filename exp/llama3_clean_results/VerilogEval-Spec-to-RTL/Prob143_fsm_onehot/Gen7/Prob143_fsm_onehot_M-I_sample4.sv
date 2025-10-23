module TopModule(
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    always @(*) begin
        next_state = 10'b0; // Initialize next_state to zero
        out1 = 1'b0; // Initialize out1 to zero
        out2 = 1'b0; // Initialize out2 to zero

        // Directly evaluate next states and outputs based on current state and input
        // This approach minimizes the combinational logic depth and could potentially improve timing
        for (int i = 0; i < 10; i++) begin
            if (state[i]) begin
                case (i)
                    0: if (!in) next_state[0] = 1'b1; else next_state[1] = 1'b1;
                    1: if (!in) next_state[0] = 1'b1; else next_state[2] = 1'b1;
                    2: if (!in) next_state[0] = 1'b1; else next_state[3] = 1'b1;
                    3: if (!in) next_state[0] = 1'b1; else next_state[4] = 1'b1;
                    4: if (!in) next_state[0] = 1'b1; else next_state[5] = 1'b1;
                    5: if (!in) next_state[8] = 1'b1; else next_state[6] = 1'b1;
                    6: if (!in) next_state[9] = 1'b1; else next_state[7] = 1'b1;
                    7: begin
                        if (!in) next_state[0] = 1'b1; else next_state[7] = 1'b1;
                        out2 = 1'b1;
                    end
                    8: begin
                        if (!in) next_state[0] = 1'b1; else next_state[1] = 1'b1;
                        out1 = 1'b1;
                    end
                    9: begin
                        if (!in) next_state[0] = 1'b1; else next_state[1] = 1'b1;
                        out1 = 1'b1;
                        out2 = 1'b1;
                    end
                    default: next_state[0] = 1'b1; // Default state
                endcase
            end
        end
    end

endmodule