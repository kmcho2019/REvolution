module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out <= 1'b0;
        end else begin
            case (state)
                OFF: begin
                    if (j == 1'b1)
                        state <= ON;
                    else
                        state <= OFF;
                    out <= 1'b0; // Moore output based on current state OFF
                end
                ON: begin
                    if (k == 1'b1)
                        state <= OFF;
                    else
                        state <= ON;
                    out <= 1'b1; // Moore output based on current state ON
                end
                default: begin
                    state <= OFF;
                    out <= 1'b0;
                end
            endcase
        end
    end

endmodule