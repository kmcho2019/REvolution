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

        case (1'b1)
            y[0]: begin // State A
                Y1 = w;  // A --1--> B
                Y3 = 1'b0;
            end
            y[1]: begin // State B
                Y1 = 1'b0;
                Y3 = ~w; // B --0--> D
            end
            y[2]: begin // State C
                Y1 = 1'b0;
                Y3 = ~w; // C --0--> D
            end
            y[3]: begin // State D
                Y1 = 1'b0;
                Y3 = 1'b0; // D transitions handled elsewhere
            end
            y[4]: begin // State E
                Y1 = 1'b0;
                Y3 = ~w; // E --0--> D
            end
            y[5]: begin // State F
                Y1 = 1'b0;
                Y3 = ~w; // F --0--> D
            end
            default: begin
                Y1 = 1'b0;
                Y3 = 1'b0;
            end
        endcase
    end

endmodule