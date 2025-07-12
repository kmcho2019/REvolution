module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101, S6 = 3'b110, S7 = 3'b111;

reg [2:0] state;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= S0;
    end else begin
        case(state)
            S0: state <= in ? S1 : S0;
            S1: state <= in ? S2 : S0;
            S2: state <= in ? S3 : S0;
            S3: state <= in ? S4 : S0;
            S4: state <= in ? S5 : S0;
            S5: state <= in ? S0 : S6;
            S6: state <= in ? S7 : S0;
            S7: state <= in ? S7 : S0;
            default: state <= S0;
        endcase
    end
end

assign disc = (state == S5) && in;
assign flag = (state == S6) && !in;
assign err = (state == S6) && in || (state == S7);

endmodule