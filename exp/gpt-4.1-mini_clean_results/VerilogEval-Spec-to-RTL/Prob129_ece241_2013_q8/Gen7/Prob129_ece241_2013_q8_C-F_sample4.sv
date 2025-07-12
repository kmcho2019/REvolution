module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding using localparams for clarity and synthesis friendliness
    localparam S_IDLE = 2'd0; // no bits matched yet, waiting for '1'
    localparam S_1    = 2'd1; // matched '1'
    localparam S_10   = 2'd2; // matched "10"

    reg [1:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        if (state == S_IDLE) begin
            if (x)
                next_state = S_1;
            else
                next_state = S_IDLE;
        end else if (state == S_1) begin
            if (x)
                next_state = S_1;
            else
                next_state = S_10;
        end else /* state == S_10 */ begin
            if (x)
                next_state = S_1;
            else
                next_state = S_IDLE;
        end
    end

    // Output logic (Mealy): asserted only when sequence "101" ends at input 'x' == 1 in S_10 state
    always @(*) begin
        z = (state == S_10) && (x == 1'b1);
    end

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

endmodule