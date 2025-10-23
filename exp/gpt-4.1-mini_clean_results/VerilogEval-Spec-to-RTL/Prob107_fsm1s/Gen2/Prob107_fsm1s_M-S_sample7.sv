module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // B state
            out <= 1'b1;
        end else begin
            case (state)
                1'b0: begin // B
                    if (in == 1'b0) state <= 1'b1; // A
                    else state <= 1'b0;
                    out <= 1'b1;
                end
                1'b1: begin // A
                    if (in == 1'b0) state <= 1'b0; // B
                    else state <= 1'b1;
                    out <= 1'b0;
                end
            endcase
        end
    end

endmodule