module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  out
);

    // Enumerated type for states (SystemVerilog style)
    typedef enum logic {B = 1'b0, A = 1'b1} state_t;
    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= B;
            out <= 1'b1; // output for state B
        end else begin
            case (state)
                B: begin
                    if (in == 1'b0) begin
                        state <= A;
                        out <= 1'b0; // output for state A
                    end else begin
                        state <= B;
                        out <= 1'b1; // output for state B
                    end
                end
                A: begin
                    if (in == 1'b0) begin
                        state <= B;
                        out <= 1'b1; // output for state B
                    end else begin
                        state <= A;
                        out <= 1'b0; // output for state A
                    end
                end
                default: begin
                    state <= B;
                    out <= 1'b1;
                end
            endcase
        end
    end

endmodule