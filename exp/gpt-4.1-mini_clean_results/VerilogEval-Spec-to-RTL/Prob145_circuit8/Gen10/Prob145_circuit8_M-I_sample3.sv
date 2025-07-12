module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

    reg [1:0] state = 2'b00;

    // State encoding:
    // 00: p=0, q=0
    // 01: p=0, q=1
    // 10: p=1, q=0
    // 11: p=1, q=1

    always @(posedge clock) begin
        // Update state based on current state and input a
        case(state)
            2'b00: state <= a ? 2'b10 : 2'b00;  // from 00 to 10 if a=1 else stay 00
            2'b10: state <= a ? 2'b11 : 2'b00;  // from 10 to 11 if a=1 else to 00
            2'b11: state <= a ? 2'b11 : 2'b01;  // from 11 stay if a=1 else to 01
            2'b01: state <= a ? 2'b10 : 2'b00;  // from 01 to 10 if a=1 else to 00
            default: state <= 2'b00;
        endcase

        // Outputs derived directly from updated state
        case(state)
            2'b00: begin p <= 0; q <= 0; end
            2'b01: begin p <= 0; q <= 1; end
            2'b10: begin p <= 1; q <= 0; end
            2'b11: begin p <= 1; q <= 1; end
            default: begin p <= 0; q <= 0; end
        endcase
    end

endmodule