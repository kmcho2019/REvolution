module TopModule(
    input a,
    input b,
    output reg out
);

    // State definition
    localparam STATE_0 = 1'b0;
    localparam STATE_1 = 1'b1;

    // Next state logic
    always @(*) begin
        case(out)
            STATE_0: out = (a & b) ? STATE_1 : STATE_0;
            STATE_1: out = (a & b) ? STATE_1 : STATE_0;
            default: out = STATE_0;
        endcase
    end

    // Initial state
    initial begin
        out = STATE_0;
    end
endmodule