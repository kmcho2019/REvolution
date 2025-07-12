module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b1; // B state (out=1)
            out   <= 1'b1;
        end else begin
            case(state)
                1'b1: begin // B state
                    if (in == 1'b0) state <= 1'b0; // move to A
                    else            state <= 1'b1; // stay in B
                    out <= 1'b1;
                end
                1'b0: begin // A state
                    if (in == 1'b0) state <= 1'b1; // move to B
                    else            state <= 1'b0; // stay in A
                    out <= 1'b0;
                end
                default: begin
                    state <= 1'b1; // default to B
                    out   <= 1'b1;
                end
            endcase
        end
    end

endmodule