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

        for (int i = 0; i < 10; i++) begin
            if (state[i]) begin
                case (i)
                    0, 1, 2, 3, 4: next_state[in? i + 1 : 0] = 1'b1;
                    5: next_state[in? 6 : 8] = 1'b1;
                    6: next_state[in? 7 : 9] = 1'b1;
                    7: begin
                        next_state[in? 7 : 0] = 1'b1;
                        out2 = 1'b1;
                    end
                    8: begin
                        next_state[in? 1 : 0] = 1'b1;
                        out1 = 1'b1;
                    end
                    9: begin
                        next_state[in? 1 : 0] = 1'b1;
                        out1 = 1'b1;
                        out2 = 1'b1;
                    end
                endcase
            end
        end
    end

endmodule