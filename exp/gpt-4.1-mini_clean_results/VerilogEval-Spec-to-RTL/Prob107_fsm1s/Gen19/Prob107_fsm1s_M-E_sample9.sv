module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // State encoding using localparams for clarity
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= B;
            out <= 1'b1;  // output for B state
        end else begin
            case (state)
                B: begin
                    state <= in ? B : A;
                    out <= 1'b1;
                end
                A: begin
                    state <= in ? A : B;
                    out <= 1'b0;
                end
                default: begin
                    state <= B;
                    out <= 1'b1;
                end
            endcase
        end
    end

endmodule