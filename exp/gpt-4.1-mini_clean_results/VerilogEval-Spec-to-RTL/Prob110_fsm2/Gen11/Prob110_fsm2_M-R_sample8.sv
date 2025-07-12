module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    // State encoding as 2-bit for potential scalability
    localparam OFF = 2'b00;
    localparam ON  = 2'b01;

    reg [1:0] state, next_state;

    // Combinational logic for next state and output
    always @(*) begin
        // Default assignments to avoid latches
        next_state = state;
        out = 1'b0;

        case (state)
            OFF: begin
                out = 1'b0;
                if (j)
                    next_state = ON;
                else
                    next_state = OFF;
            end
            ON: begin
                out = 1'b1;
                if (k)
                    next_state = OFF;
                else
                    next_state = ON;
            end
            default: begin
                out = 1'b0;
                next_state = OFF;
            end
        endcase
    end

    // Sequential block with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

endmodule