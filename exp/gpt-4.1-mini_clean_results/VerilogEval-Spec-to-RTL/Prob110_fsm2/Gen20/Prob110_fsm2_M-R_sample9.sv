module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    // State encoding as one-hot bits: [1] = ON, [0] = OFF
    reg [1:0] state, next_state;

    // Next state combinational logic as continuous assignments
    // OFF state transitions: OFF -> ON if j=1, else stays OFF
    wire off_to_on = j;
    // ON state transitions: ON -> OFF if k=1, else stays ON
    wire on_to_off = k;

    // Compute next_state bits
    assign next_state[0] = (state[0] & ~off_to_on) | (state[1] & on_to_off); // OFF state bit
    assign next_state[1] = (state[0] & off_to_on)  | (state[1] & ~on_to_off); // ON state bit

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;  // OFF state
        else
            state <= next_state;
    end

    // Output logic: out=1 if ON state active, else 0
    assign out = state[1];

endmodule