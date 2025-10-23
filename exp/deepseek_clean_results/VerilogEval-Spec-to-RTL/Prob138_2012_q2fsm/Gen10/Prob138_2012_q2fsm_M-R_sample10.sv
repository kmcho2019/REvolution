module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Gray code state encoding with z output as MSB
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b011,
                     D = 3'b010,
                     E = 3'b110,
                     F = 3'b111;

    reg [2:0] state;

    // State transition logic using bitwise operations
    wire [2:0] next_state = 
        (state == A) ? (w ? B : A) :
        (state == B) ? (w ? C : D) :
        (state == C) ? (w ? E : D) :
        (state == D) ? (w ? F : A) :
        (state == E) ? (w ? E : D) :
        (state == F) ? (w ? C : D) :
        A;  // default case

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output z is the MSB of state (E and F have this bit set)
    assign z = state[2];

endmodule