module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // One-hot state encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    reg [3:0] state, next_state;

    // Asynchronous reset and state register (one-hot)
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;      // Reset to state A (only bit 0 set)
        else
            state <= next_state;
    end

    // Next state logic combinational
    always @(*) begin
        // Default no change
        next_state = 4'b0000;

        case (state)
            A: begin
                if (in)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if (in)
                    next_state = B;
                else
                    next_state = C;
            end
            C: begin
                if (in)
                    next_state = D;
                else
                    next_state = A;
            end
            D: begin
                if (in)
                    next_state = B;
                else
                    next_state = C;
            end
            default: next_state = A; // Safety default
        endcase
    end

    // Output logic (Moore): output is 1 only in state D
    always @(*) begin
        out = (state == D) ? 1'b1 : 1'b0;
    end

endmodule