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
    
    // State transition logic
    case (1'b1)
        y[0]: begin // State A
            Y1 = w;  // Transition to B when w=1
            Y3 = 1'b0;
        end
        y[1]: begin // State B
            Y3 = ~w; // Transition to D when w=0
        end
        y[2]: begin // State C
            Y3 = ~w; // Transition to D when w=0
        end
        // Other states don't affect Y1 or Y3 outputs
        default: begin
            Y1 = 1'b0;
            Y3 = 1'b0;
        end
    endcase
end

endmodule