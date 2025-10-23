module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // One-hot state encoding
    localparam B = 2'b01;
    localparam A = 2'b10;

    reg [1:0] state, next_state;

    // Next-state logic using case statement for clarity
    always @(*) begin
        case(state)
            B: begin
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = B;
            end
            A: begin
                if (in == 1'b0)
                    next_state = B;
                else
                    next_state = A;
            end
            default: next_state = B; // safe fallback
        endcase
    end

    // Synchronous reset and state update
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output logic: output=1 in B state, else 0
    always @(*) begin
        case(state)
            B: out = 1'b1;
            A: out = 1'b0;
            default: out = 1'b1;
        endcase
    end

endmodule