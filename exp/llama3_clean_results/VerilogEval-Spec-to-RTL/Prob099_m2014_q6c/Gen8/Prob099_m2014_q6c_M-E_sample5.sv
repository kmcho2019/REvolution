module StateTransition(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    reg Y1_reg;
    reg Y3_reg;

    always @(y or w) begin
        case (1'b1)
            y[0]: begin // State A
                Y1_reg = ~w;
                Y3_reg = 1'b0;
            end
            y[1]: begin // State B
                Y1_reg = 1'b0;
                Y3_reg = w;
            end
            y[2]: begin // State C
                Y1_reg = 1'b0;
                Y3_reg = w;
            end
            y[3]: begin // State D
                Y1_reg = 1'b0;
                Y3_reg = 1'b0;
            end
            y[4]: begin // State E
                Y1_reg = 1'b0;
                Y3_reg = ~w;
            end
            y[5]: begin // State F
                Y1_reg = 1'b0;
                Y3_reg = 1'b0;
            end
        endcase
    end

    assign Y1 = Y1_reg;
    assign Y3 = Y3_reg;

endmodule

module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    StateTransition state_transition(y, w, Y1, Y3);

endmodule