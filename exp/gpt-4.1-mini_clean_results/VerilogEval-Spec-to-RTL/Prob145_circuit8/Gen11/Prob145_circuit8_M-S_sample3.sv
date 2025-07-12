module TopModule(
    input clock,
    input a,
    output p,
    output q
);

    reg [1:0] state;

    // State encoding: {p, q}
    localparam S00 = 2'b00;
    localparam S10 = 2'b10;
    localparam S11 = 2'b11;
    localparam S01 = 2'b01;

    assign p = state[1];
    assign q = state[0];

    always @(posedge clock) begin
        if (state === 2'bxx) begin
            state <= S00; // Initialize unknown state to S00
        end else begin
            case(state)
                S00: state <= a ? S10 : S00;
                S10: state <= a ? S11 : S00;
                S11: state <= a ? S11 : S01;
                S01: state <= a ? S11 : S01;
                default: state <= S00;
            endcase
        end
    end

endmodule