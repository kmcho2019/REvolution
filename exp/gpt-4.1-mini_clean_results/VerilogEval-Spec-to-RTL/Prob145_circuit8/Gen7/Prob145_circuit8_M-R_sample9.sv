module TopModule(
    input clock,
    input a,
    output p,
    output q
);

    // 2-bit state register with explicit initialization
    reg [1:0] state = 2'b00;

    // State transition on positive edge of clock
    always @(posedge clock) begin
        case (state)
            2'b00: state <= a ? 2'b01 : 2'b00;
            2'b01: state <= a ? 2'b11 : 2'b00;
            2'b11: state <= a ? 2'b11 : 2'b10;
            2'b10: state <= a ? 2'b11 : 2'b00;
            default: state <= 2'b00;
        endcase
    end

    // Outputs as continuous assignments reflecting state bits
    assign p = state[0];
    assign q = state[1];

endmodule