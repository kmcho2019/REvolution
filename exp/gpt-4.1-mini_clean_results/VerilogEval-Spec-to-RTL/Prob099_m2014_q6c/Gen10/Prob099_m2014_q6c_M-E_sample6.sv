module TopModule (
    input  [5:0] y,  // one-hot encoded current state: A..F = y[0]..y[5]
    input        w,  // input signal
    output reg   Y1, // next state signal for state B (y[1])
    output reg   Y3  // next state signal for state D (y[3])
);

always @(*) begin
    // Default outputs
    Y1 = 1'b0;
    Y3 = 1'b0;

    case (1'b1) // priority encoder for one-hot y
        y[0]: begin // State A
            Y1 = ~w;    // A --0--> B
            Y3 = 1'b0;  // no D transition from A
        end
        y[1]: begin // State B
            Y1 = 1'b0;      // no B next from B
            Y3 = w;         // B --1--> D
        end
        y[2]: begin // State C
            Y1 = 1'b0;
            Y3 = w;         // C --1--> D
        end
        y[3]: begin // State D
            Y1 = 1'b0;
            Y3 = 1'b0;      // No next D (y[3]) from D next transition w.r.t. problem
        end
        y[4]: begin // State E
            Y1 = 1'b0;
            Y3 = w;         // E --1--> D
        end
        y[5]: begin // State F
            Y1 = 1'b0;
            Y3 = w;         // F --1--> D
        end
        default: begin
            Y1 = 1'b0;
            Y3 = 1'b0;
        end
    endcase
end

endmodule