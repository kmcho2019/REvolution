module TopModule (
    input wire clk,
    input wire rst_n,
    input wire x,
    input wire y,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        S00, // both inputs 0
        S10, // x=1,y=0
        S01, // x=0,y=1
        S11  // both inputs 1
    } state_t;

    state_t state, next_state;

    // Clocked state transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= S00;
        else
            state <= next_state;
    end

    // Next state logic based on inputs
    always @(*) begin
        case ({x,y})
            2'b00: next_state = S00;
            2'b10: next_state = S10;
            2'b01: next_state = S01;
            2'b11: next_state = S11;
            default: next_state = S00;
        endcase
    end

    // Output logic based on current state
    always @(*) begin
        case (state)
            S00: z = 1'b1;
            S11: z = 1'b1;
            default: z = 1'b0;
        endcase
    end

endmodule