module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // States: 0 - reset, 1-6 - consecutive 1s count, 7 - error
reg discReg;
reg flagReg;
reg errReg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        discReg <= 0;
        flagReg <= 0;
        errReg <= 0;
    end else begin
        case (state)
            0: begin
                if (in) begin
                    state <= 1;
                end else begin
                    state <= 0;
                end
                discReg <= 0;
                flagReg <= 0;
                errReg <= 0;
            end
            1: begin
                if (in) begin
                    state <= 2;
                end else begin
                    state <= 0;
                end
                discReg <= 0;
                flagReg <= 0;
                errReg <= 0;
            end
            2: begin
                if (in) begin
                    state <= 3;
                end else begin
                    state <= 0;
                end
                discReg <= 0;
                flagReg <= 0;
                errReg <= 0;
            end
            3: begin
                if (in) begin
                    state <= 4;
                end else begin
                    state <= 0;
                end
                discReg <= 0;
                flagReg <= 0;
                errReg <= 0;
            end
            4: begin
                if (in) begin
                    state <= 5;
                end else begin
                    state <= 0;
                end
                discReg <= 0;
                flagReg <= 0;
                errReg <= 0;
            end
            5: begin
                if (in) begin
                    state <= 6;
                end else begin
                    state <= 0;
                end
                discReg <= 0;
                flagReg <= 0;
                errReg <= 0;
            end
            6: begin
                if (in) begin
                    state <= 7;
                    errReg <= 1;
                end else begin
                    state <= 0;
                    discReg <= 1;
                    flagReg <= 1;
                end
            end
            7: begin
                if (!in) begin
                    state <= 0;
                end else begin
                    state <= 7;
                end
                discReg <= 0;
                flagReg <= 0;
                errReg <= 1;
            end
            default: begin
                state <= 0;
                discReg <= 0;
                flagReg <= 0;
                errReg <= 0;
            end
        endcase
    end
end

assign disc = discReg;
assign flag = flagReg;
assign err = errReg;

endmodule