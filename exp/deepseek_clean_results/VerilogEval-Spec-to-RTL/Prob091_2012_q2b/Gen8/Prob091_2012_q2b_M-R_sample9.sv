module TopModule (
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

always @(*) begin
    // Default outputs
    Y1 = 1'b0;
    Y3 = 1'b0;
    
    case (1'b1) // One-hot case statement
        y[0]: begin // State A
            Y1 = w; // Transition to B when w=1
            Y3 = 1'b0;
        end
        y[1]: begin // State B
            Y1 = 1'b0;
            Y3 = ~w; // Transition to D when w=0
        end
        y[2]: begin // State C
            Y1 = 1'b0;
            Y3 = ~w; // Transition to D when w=0
        end
        y[3]: begin // State D
            Y1 = 1'b0;
            Y3 = ~w; // Transition to A when w=0
        end
        y[4]: begin // State E
            Y1 = 1'b0;
            Y3 = ~w; // Transition to D when w=0
        end
        y[5]: begin // State F
            Y1 = 1'b0;
            Y3 = ~w; // Transition to D when w=0
        end
        default: begin
            Y1 = 1'b0;
            Y3 = 1'b0;
        end
    endcase
end

endmodule