module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y2,
    output reg Y3,
    output reg Y4
);

always @(y or w) begin
    case (1'b1)
        y[0]: begin // State A
            Y1 = 0;
            Y2 = ~w;
            Y3 = 0;
            Y4 = 0;
        end
        y[1]: begin // State B
            Y1 = 0;
            Y2 = 0;
            Y3 = ~w;
            Y4 = 0;
        end
        y[2]: begin // State C
            Y1 = 0;
            Y2 = 0;
            Y3 = 0;
            Y4 = ~w;
        end
        y[3]: begin // State D
            Y1 = w;
            Y2 = 0;
            Y3 = 0;
            Y4 = 0;
        end
        y[4]: begin // State E
            Y1 = 0;
            Y2 = 0;
            Y3 = 0;
            Y4 = 0;
        end
        y[5]: begin // State F
            Y1 = 0;
            Y2 = 0;
            Y3 = ~w;
            Y4 = 0;
        end
        default: begin
            Y1 = 0;
            Y2 = 0;
            Y3 = 0;
            Y4 = 0;
        end
    endcase
end

endmodule