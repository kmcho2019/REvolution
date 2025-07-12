module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state;
localparam S0 = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;
localparam S6 = 3'b110;
localparam S7 = 3'b111;

always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        case (state)
            S0: begin
                if (in) state <= S1;
                else state <= S0;
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
            S1: begin
                if (in) state <= S2;
                else state <= S0;
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
            S2: begin
                if (in) state <= S3;
                else state <= S0;
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
            S3: begin
                if (in) state <= S4;
                else state <= S0;
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
            S4: begin
                if (in) state <= S5;
                else state <= S0;
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
            S5: begin
                if (in) state <= S6;
                else begin
                    state <= S0;
                    disc <= 1'b1;
                end
                flag <= 1'b0;
                err <= 1'b0;
            end
            S6: begin
                if (in) state <= S7;
                else begin
                    state <= S0;
                    flag <= 1'b1;
                end
                disc <= 1'b0;
                err <= 1'b0;
            end
            S7: begin
                if (in) state <= S7;
                else state <= S0;
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b1;
            end
            default: state <= S0;
        endcase
    end
end

endmodule