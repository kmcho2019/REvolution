module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state;
localparam S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101, S6 = 3'b110, S7 = 3'b111;

always @ (posedge clk) begin
    if (reset) begin
        state <= S0;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        case (state)
            S0: if (in) state <= S1; else state <= S0;
            S1: if (in) state <= S2; else state <= S0;
            S2: if (in) state <= S3; else state <= S0;
            S3: if (in) state <= S4; else state <= S0;
            S4: if (in) state <= S5; else state <= S0;
            S5: if (in) state <= S6; else state <= S0;
            S6: if (in) state <= S7; else state <= S1;
            S7: if (in) state <= S7; else state <= S0;
        endcase

        case (state)
            S5: disc <= in;
            default: disc <= 1'b0;
        endcase

        case (state)
            S6: flag <= ~in;
            default: flag <= 1'b0;
        endcase

        case (state)
            S7: err <= 1'b1;
            default: err <= 1'b0;
        endcase
    end
end

endmodule