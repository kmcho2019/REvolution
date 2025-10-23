module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire j,
    input  wire k,
    output reg  out
);

    // State encoding: OFF=0, ON=1
    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0; // OFF state
            out   <= 1'b0; // output 0 in OFF
        end else begin
            case(state)
                1'b0: begin // OFF
                    if (j)
                        state <= 1'b1; // ON
                    else
                        state <= 1'b0; // stay OFF
                    out <= 1'b0;       // output 0 in OFF
                end
                1'b1: begin // ON
                    if (k)
                        state <= 1'b0; // OFF
                    else
                        state <= 1'b1; // stay ON
                    out <= 1'b1;       // output 1 in ON
                end
                default: begin
                    state <= 1'b0;
                    out   <= 1'b0;
                end
            endcase
        end
    end

endmodule