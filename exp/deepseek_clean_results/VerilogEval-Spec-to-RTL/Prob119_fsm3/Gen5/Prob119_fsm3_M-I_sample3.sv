module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    // One-hot state encoding
    parameter A = 4'b0001;
    parameter B = 4'b0010;
    parameter C = 4'b0100;
    parameter D = 4'b1000;

    // State register (one-hot)
    reg [3:0] state;

    // State transition and output logic (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
            out <= 1'b0;
        end else begin
            case (state)
                A: begin
                    state <= in ? B : A;
                    out <= 1'b0;
                end
                B: begin
                    state <= in ? B : C;
                    out <= 1'b0;
                end
                C: begin
                    state <= in ? D : A;
                    out <= 1'b0;
                end
                D: begin
                    state <= in ? B : C;
                    out <= 1'b1;
                end
                default: begin  // Safety net
                    state <= A;
                    out <= 1'b0;
                end
            endcase
        end
    end

endmodule