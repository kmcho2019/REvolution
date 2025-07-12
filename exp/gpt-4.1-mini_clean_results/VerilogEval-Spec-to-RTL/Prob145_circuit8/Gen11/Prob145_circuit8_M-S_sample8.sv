module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

    reg [1:0] state;

    always @(posedge clock) begin
        case (state)
            2'b00: state <= a ? 2'b01 : 2'b00;
            2'b01: state <= a ? 2'b11 : 2'b00;
            2'b11: state <= a ? 2'b11 : 2'b10;
            2'b10: state <= a ? 2'b11 : 2'b00;
            default: state <= 2'b00;
        endcase
        // Update outputs from state
        p <= state[0];
        q <= state[1];
    end

    // Initialize state and outputs
    initial begin
        state = 2'b00;
        p = 0;
        q = 0;
    end

endmodule