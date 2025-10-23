module TopModule (
    input  [5:0] y,  // one-hot encoded current state: A..F = y[0]..y[5]
    input        w,  // input signal
    output reg   Y2, // next state signal for state B (y[1])
    output reg   Y4  // next state signal for state D (y[3])
);

always @(*) begin
    // Default outputs
    Y2 = 1'b0;
    Y4 = 1'b0;

    case (1'b1) // priority encoder for one-hot y
        y[0]: begin // State A
            Y2 = ~w;    // A --0--> B
            Y4 = 1'b0;  // no D transition from A
        end
        y[1]: begin // State B
            Y2 = 1'b0;      // no B next from B
            Y4 = w;         // B --1--> D
        end
        y[2]: begin // State C
            Y2 = 1'b0;
            Y4 = w;         // C --1--> D
        end
        y[3]: begin // State D
            Y2 = 1'b0;
            Y4 = 1'b0;      // no next D from D in this context
        end
        y[4]: begin // State E
            Y2 = 1'b0;
            Y4 = w;         // E --1--> D
        end
        y[5]: begin // State F
            Y2 = 1'b0;
            Y4 = w;         // F --1--> D
        end
        default: begin
            Y2 = 1'b0;
            Y4 = 1'b0;
        end
    endcase
end

endmodule