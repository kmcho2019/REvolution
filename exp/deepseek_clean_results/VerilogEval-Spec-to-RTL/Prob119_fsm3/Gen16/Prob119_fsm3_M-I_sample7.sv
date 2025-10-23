module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    // One-hot state encoding
    parameter [3:0] A = 4'b0001,
                    B = 4'b0010,
                    C = 4'b0100,
                    D = 4'b1000;

    reg [3:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
            out <= 1'b0;
        end else begin
            case (1'b1) // synthesis parallel_case
                state[A]: begin
                    state <= in ? B : A;
                    out <= 1'b0;
                end
                state[B]: begin
                    state <= in ? B : C;
                    out <= 1'b0;
                end
                state[C]: begin
                    state <= in ? D : A;
                    out <= 1'b0;
                end
                state[D]: begin
                    state <= in ? B : C;
                    out <= 1'b1;
                end
            endcase
        end
    end

endmodule