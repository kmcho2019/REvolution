module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

reg [1:0] state; // 2-bit state register to encode 5 states
reg start_shifting_reg; // register to store start_shifting value

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // reset state to S0
        start_shifting_reg <= 0; // reset start_shifting to 0
    end else begin
        case (state)
            0: begin // S0
                if (data) state <= 1; // matched '1', move to S1
                else state <= 0; // no match, stay in S0
            end
            1: begin // S1
                if (data) state <= 2; // matched '11', move to S2
                else state <= 0; // no match, reset to S0
            end
            2: begin // S2
                if (~data) state <= 3; // matched '110', move to S3
                else state <= 1; // matched '11', stay in S1
            end
            3: begin // S3
                if (data) state <= 4; // matched '1101', move to S4
                else state <= 0; // no match, reset to S0
            end
            4: begin // S4
                start_shifting_reg <= 1; // set start_shifting to 1
            end
        endcase
    end
end

assign start_shifting = start_shifting_reg;

endmodule