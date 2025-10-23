module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= B;
            out <= 1'b1;
        end else begin
            case(state)
                B: begin
                    out <= 1'b1;
                    state <= in ? B : A;
                end
                A: begin
                    out <= 1'b0;
                    state <= in ? A : B;
                end
            endcase
        end
    end

endmodule