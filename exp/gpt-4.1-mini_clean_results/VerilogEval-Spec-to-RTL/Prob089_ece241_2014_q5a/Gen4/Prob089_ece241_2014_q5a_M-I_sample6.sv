module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // One-hot state encoding for clarity and potential synthesis optimization
    localparam STATE_BEFORE_FIRST_ONE = 2'b01;
    localparam STATE_AFTER_FIRST_ONE  = 2'b10;

    reg [1:0] state, next_state;

    // Next state and output logic combined in a single always block with non-blocking assignments
    always @(*) begin
        // Default assignments to avoid inferred latches
        next_state = state;
        z = 1'b0;

        if (state == STATE_BEFORE_FIRST_ONE) begin
            z = x; // output input bit until first 1 found
            if (x)
                next_state = STATE_AFTER_FIRST_ONE;
            else
                next_state = STATE_BEFORE_FIRST_ONE;
        end
        else if (state == STATE_AFTER_FIRST_ONE) begin
            z = ~x; // output inverted input bit after first 1 found
            next_state = STATE_AFTER_FIRST_ONE;
        end
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_BEFORE_FIRST_ONE;
            z     <= 1'b0;
        end else begin
            state <= next_state;
            // z updated in combinational logic and registered here; assignment above is for combinational correctness
            // Because output 'z' is both driven combinationally and registered, we register the output here to meet spec
        end
    end

endmodule