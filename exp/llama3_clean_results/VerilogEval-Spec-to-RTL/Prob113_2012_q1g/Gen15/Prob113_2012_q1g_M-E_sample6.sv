module TopModule(
    input  [3:0] x,
    output       f
);

    // Define the states
    reg [1:0] state;
    parameter S00 = 2'b00, S01 = 2'b01, S10 = 2'b10, S11 = 2'b11;

    // Initialize the state
    initial state = S00;

    // State transition logic
    always @(*) begin
        case({x[2], x[3]})
            2'b00: state = S00;
            2'b01: state = S01;
            2'b10: state = S10;
            2'b11: state = S11;
            default: state = S00;
        endcase
    end

    // Output logic based on the state and x[0], x[1]
    always @(*) begin
        case(state)
            S00: f = (~x[0] & ~x[1]) | (x[0] & ~x[1]);
            S01: f = 1'b0;
            S10: f = (~x[0] & ~x[1]) | (~x[0] & x[1]) | (x[0] & ~x[1]) | (x[0] & x[1]);
            S11: f = (~x[0] & ~x[1]) | (~x[0] & x[1]) | (x[0] & x[1]);
            default: f = 1'b0;
        endcase
    end

endmodule