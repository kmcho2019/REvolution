module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    // State encoding: state = out
    // OFF = 0, ON = 1
    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // OFF state
            out <= 1'b0;
        end else begin
            // State transitions and output update
            case (state)
                1'b0: begin // OFF state
                    state <= (j) ? 1'b1 : 1'b0; 
                    out <= (j) ? 1'b1 : 1'b0;
                end
                1'b1: begin // ON state
                    state <= (k) ? 1'b0 : 1'b1;
                    out <= (k) ? 1'b0 : 1'b1;
                end
            endcase
        end
    end

endmodule