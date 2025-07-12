module TopModule (
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
            out <= 1'b1; // output for state B
        end else begin
            case (state)
                B: begin
                    if (in == 1'b0) begin
                        state <= A;
                        out <= 1'b0; // output for A
                    end else begin
                        state <= B;
                        out <= 1'b1; // output for B
                    end
                end
                A: begin
                    if (in == 1'b0) begin
                        state <= B;
                        out <= 1'b1; // output for B
                    end else begin
                        state <= A;
                        out <= 1'b0; // output for A
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