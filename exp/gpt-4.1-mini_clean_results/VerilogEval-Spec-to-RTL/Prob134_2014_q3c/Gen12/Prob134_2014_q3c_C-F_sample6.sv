module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    reg [2:0] state;       // internal registered present state
    reg [2:0] next_state;  // next state logic computed combinationally

    // Synchronous update of internal state register
    always @(posedge clk) begin
        state <= y;
    end

    // Next state logic: combinational, depends on registered state and input x
    always @(*) begin
        case (state)
            3'b000: next_state = (x == 1'b0) ? 3'b000 : 3'b001;
            3'b001: next_state = (x == 1'b0) ? 3'b001 : 3'b100;
            3'b010: next_state = (x == 1'b0) ? 3'b010 : 3'b001;
            3'b011: next_state = (x == 1'b0) ? 3'b001 : 3'b010;
            3'b100: next_state = (x == 1'b0) ? 3'b011 : 3'b100;
            default: next_state = 3'b000;
        endcase
    end

    // Output logic z depends combinationally on registered present state
    assign z = (state == 3'b011) || (state == 3'b100);

    // Output Y0 is least significant bit of the next state
    assign Y0 = next_state[0];

endmodule