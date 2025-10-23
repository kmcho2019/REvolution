module NextStateModule(
    input  in,
    input [1:0] state,
    output [1:0] next_state
);

    reg [1:0] next_state_reg;

    always @(*) begin
        case({in, state})
            3'b000: next_state_reg = 2'b00;
            3'b001: next_state_reg = 2'b01;
            3'b010: next_state_reg = 2'b00;
            3'b011: next_state_reg = 2'b01;
            3'b100: next_state_reg = 2'b01;
            3'b101: next_state_reg = 2'b01;
            3'b110: next_state_reg = 2'b10;
            3'b111: next_state_reg = 2'b11;
            default: next_state_reg = 2'b00;
        endcase
    end

    assign next_state = next_state_reg;

endmodule

module OutputModule(
    input [1:0] state,
    output out
);

    reg out_reg;

    always @(*) begin
        case(state)
            2'b00: out_reg = 1'b0;
            2'b01: out_reg = 1'b0;
            2'b10: out_reg = 1'b0;
            2'b11: out_reg = 1'b1;
            default: out_reg = 1'b0;
        endcase
    end

    assign out = out_reg;

endmodule

module TopModule(
    input  in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

    wire [1:0] next_state_wire;
    wire out_wire;

    NextStateModule next_state_module(
       .in(in),
       .state(state),
       .next_state(next_state_wire)
    );

    OutputModule output_module(
       .state(state),
       .out(out_wire)
    );

    assign next_state = next_state_wire;
    assign out = out_wire;

endmodule