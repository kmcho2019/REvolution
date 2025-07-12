module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    // One-hot encoding of states
    localparam OFF = 2'b01;
    localparam ON  = 2'b10;

    reg [1:0] state;
    reg [1:0] next_state;

    // Asynchronous reset handled in a separate always block
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            OFF: next_state = (j) ? ON : OFF;
            ON : next_state = (k) ? OFF : ON;
            default: next_state = OFF; // safe fallback
        endcase
    end

    // Moore output logic based on current state
    always @(*) begin
        case (state)
            OFF: out = 1'b0;
            ON : out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule