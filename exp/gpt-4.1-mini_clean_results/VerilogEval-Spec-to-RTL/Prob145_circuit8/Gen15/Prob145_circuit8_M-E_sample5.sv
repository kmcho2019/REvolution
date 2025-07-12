module TopModule(
    input        clock,
    input        a,
    output reg   p,
    output reg   q
);

    reg [1:0] state;

    always @(posedge clock) begin
        state <= {state[0], a};  // Shift left and insert a
        p <= state[1];           // p is previous LSB of state before shift
        q <= state[0];           // q is previous LSB after shift (previous a)
    end

endmodule