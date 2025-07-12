module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    // Define states
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    // State register with combined output
    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
            out <= 0;
        end else begin
            case (state)
                A: begin state <= in ? B : A; out <= 0; end
                B: begin state <= in ? B : C; out <= 0; end
                C: begin state <= in ? D : A; out <= 0; end
                D: begin state <= in ? B : C; out <= 1; end
            endcase
        end
    end

endmodule