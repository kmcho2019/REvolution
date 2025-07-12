module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0; // B state
            out <= 1'b1;
        end else begin
            case(state)
                1'b0: begin // B
                    out <= 1'b1;
                    state <= (in == 1'b0) ? 1'b1 : 1'b0;
                end
                1'b1: begin // A
                    out <= 1'b0;
                    state <= (in == 1'b0) ? 1'b0 : 1'b1;
                end
            endcase
        end
    end

endmodule