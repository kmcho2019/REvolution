module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// Binary encoded states matching output values
localparam [2:0] S4 = 3'd4,
                 S5 = 3'd5,
                 S6 = 3'd6,
                 S0 = 3'd0,
                 S1 = 3'd1;

reg [2:0] state;

always @(posedge clk) begin
    if (a) begin
        // Hold current state when a=1
        state <= state;
    end else begin
        // Count down sequence when a=0
        case (state)
            S4: state <= S5;
            S5: state <= S6;
            S6: state <= S0;
            S0: state <= S1;
            S1: state <= S4; // Wrap around
            default: state <= S4;
        endcase
    end
    q <= state; // Direct state to output mapping
end

initial begin
    state = S4;
    q = S4;
end

endmodule