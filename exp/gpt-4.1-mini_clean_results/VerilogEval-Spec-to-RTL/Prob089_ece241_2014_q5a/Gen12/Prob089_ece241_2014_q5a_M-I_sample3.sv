module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // State encoding
    localparam WAIT_FOR_ONE = 1'b0;  // Copy input until first '1' detected
    localparam INVERTING    = 1'b1;  // Invert bits after first '1'

    reg state;

    // Sequential logic: state register with asynchronous reset
    // Sample input and update state together to reduce registers
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WAIT_FOR_ONE;
        else begin
            case (state)
                WAIT_FOR_ONE: state <= (x == 1'b1) ? INVERTING : WAIT_FOR_ONE;
                INVERTING:    state <= INVERTING;
                default:      state <= WAIT_FOR_ONE;
            endcase
        end
    end

    // Output logic as continuous assignment for minimal logic depth
    // Moore output depends on current state and input (x)
    assign z = (state == WAIT_FOR_ONE) ? x : ~x;

endmodule