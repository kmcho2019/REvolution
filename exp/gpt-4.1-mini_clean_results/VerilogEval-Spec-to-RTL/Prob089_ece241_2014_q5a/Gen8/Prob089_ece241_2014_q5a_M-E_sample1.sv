module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam S0 = 1'b0; // COPY state
    localparam S1 = 1'b1; // INVERT state

    reg state, next_state;
    reg output_bit; // Moore output bit depending only on state

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            S0: begin
                if (x == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: next_state = S1;
            default: next_state = S0;
        endcase
    end

    // Output bit assignment based only on current state (Moore output)
    always @(*) begin
        case(state)
            S0: output_bit = 1'b0; // pass bits as-is
            S1: output_bit = 1'b1; // invert bits
            default: output_bit = 1'b0;
        endcase
    end

    // Output logic: XOR of input x with Moore output bit
    // This output combinational logic ensures output is stable within clock cycle after state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            z <= 1'b0;
        end else begin
            z <= x ^ output_bit;
        end
    end

endmodule