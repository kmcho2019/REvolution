module TopModule(
    input [5:0] y,
    input w,
    output Y2,
    output Y4
);

// Use a case statement to explicitly define next-state conditions
always @(*) begin
    case (1'b1)
        y[0]: begin // State A
            Y2 = ~w; // Transition to B if w is 0
            Y4 = 0;  // No direct transition to D
        end
        y[1]: begin // State B
            Y2 = w; // Stay in B if w is 1
            Y4 = ~w; // Transition to D if w is 0
        end
        y[2]: begin // State C
            Y2 = 0;  // No transition to B
            Y4 = ~w; // Transition to D if w is 0
        end
        y[3]: begin // State D
            Y2 = 0;  // No transition to B
            Y4 = 1;  // Stay in D or transition based on other conditions
        end
        y[4]: begin // State E
            Y2 = 0;  // No transition to B
            Y4 = ~w; // Transition to D if w is 0
        end
        y[5]: begin // State F
            Y2 = 0;  // No transition to B
            Y4 = ~w; // Transition to D if w is 0
        end
    endcase
end

endmodule