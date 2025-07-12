module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// One-hot encoding: A = 000001, B = 000010, C = 000100, D = 001000, E = 010000, F = 100000

// Define the next-state values for Y1 and Y3
reg Y1_next, Y3_next;

always @(*) begin
    case (1'b1)
        y[0]: begin // State A
            Y1_next = ~w;
            Y3_next = 1'b0;
        end
        y[1]: begin // State B
            Y1_next = 1'b0;
            Y3_next = ~w;
        end
        y[2]: begin // State C
            Y1_next = 1'b0;
            Y3_next = ~w;
        end
        y[3]: begin // State D
            Y1_next = 1'b0;
            Y3_next = w;
        end
        y[4]: begin // State E
            Y1_next = 1'b0;
            Y3_next = w;
        end
        y[5]: begin // State F
            Y1_next = w;
            Y3_next = 1'b0;
        end
    endcase
end

assign Y1 = Y1_next;
assign Y3 = Y3_next;

endmodule