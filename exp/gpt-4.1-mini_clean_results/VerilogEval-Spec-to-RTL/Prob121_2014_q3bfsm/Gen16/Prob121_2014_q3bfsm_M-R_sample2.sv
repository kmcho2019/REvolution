module TopModule (
    input  clk,
    input  reset,
    input  x,
    output z
);

    // State encoding using localparam for clarity
    localparam S0 = 3'b000,
               S1 = 3'b001,
               S2 = 3'b010,
               S3 = 3'b011,
               S4 = 3'b100;

    reg [2:0] state;

    // Combinational logic for next state bits
    wire [2:0] next_state;

    assign next_state[2] = 
        (state == S1 && x) ||           // S1 -> S4 on x=1
        (state == S4 && x);             // S4 -> S4 on x=1

    assign next_state[1] =
        (state == S0 && x) ||           // S0 -> S1 on x=1
        (state == S2 && x) ||           // S2 -> S1 on x=1
        (state == S3 && ~x);            // S3 -> S1 on x=0

    assign next_state[0] =
        (state == S0 && ~x) ||          // S0 -> S0 on x=0
        (state == S1 && ~x) ||          // S1 -> S1 on x=0
        (state == S2 && ~x) ||          // S2 -> S2 on x=0
        (state == S3 && x) ||           // S3 -> S2 on x=1
        (state == S4 && ~x);            // S4 -> S3 on x=0

    // Sequential logic: update state on clk posedge with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output logic: z=1 only in states S3 and S4
    assign z = (state == S3) || (state == S4);

endmodule