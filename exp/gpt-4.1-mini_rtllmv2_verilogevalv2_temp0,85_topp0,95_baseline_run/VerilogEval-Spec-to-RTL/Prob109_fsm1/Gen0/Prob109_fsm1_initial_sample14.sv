module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;  // Asynchronous reset to state B
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            B: begin
                if (in == 0)
                    next_state = A;
                else
                    next_state = B;
            end
            A: begin
                if (in == 0)
                    next_state = B;
                else
                    next_state = A;
            end
            default: next_state = B; // default safe state
        endcase
    end

    // Moore output depends only on state
    always @(*) begin
        case (state)
            A: out = 1'b0;
            B: out = 1'b1;
            default: out = 1'b1;
        endcase
    end

endmodule