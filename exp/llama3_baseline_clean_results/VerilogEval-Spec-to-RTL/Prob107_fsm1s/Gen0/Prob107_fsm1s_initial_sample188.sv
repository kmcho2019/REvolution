module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [0:0] state; // 1-bit register to store the current state
parameter B = 1'b1; // state B
parameter A = 1'b0; // state A

always @(posedge clk) begin
    if (reset) begin // reset is active-high synchronous
        state <= B; // reset state is B
    end else begin
        case (state)
            B: begin
                if (~in) begin // in = 0
                    state <= A;
                end else begin // in = 1
                    state <= B;
                end
            end
            A: begin
                if (~in) begin // in = 0
                    state <= B;
                end else begin // in = 1
                    state <= A;
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        B: out = 1'b1;
        A: out = 1'b0;
    endcase
end

endmodule