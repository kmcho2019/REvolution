module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // State encoding
    localparam WAIT   = 1'b0; // Waiting for first '1' bit
    localparam INVERT = 1'b1; // Invert bits after first '1' encountered

    reg state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            WAIT: 
                next_state = (x == 1'b1) ? INVERT : WAIT;
            INVERT:
                next_state = INVERT;
            default:
                next_state = WAIT;
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WAIT;
        else
            state <= next_state;
    end

    // Output logic (Mealy): depends on current input and state
    assign z = (state == WAIT) ? x : ~x;

endmodule