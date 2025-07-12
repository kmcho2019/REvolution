module TopModule(
    input clock,
    input a,
    output p,
    output q
);

    reg [1:0] state;

    // Initialize state to 00 at simulation start
    initial begin
        state = 2'b00;
    end

    always @(posedge clock) begin
        case (state)
            2'b00: state <= a ? 2'b01 : 2'b00;
            2'b01: state <= a ? 2'b11 : 2'b00;
            2'b11: state <= a ? 2'b11 : 2'b10;
            2'b10: state <= a ? 2'b11 : 2'b00;
            default: state <= 2'b00;
        endcase
    end

    // Outputs directly assigned from state bits
    assign p = state[0];
    assign q = state[1];

endmodule