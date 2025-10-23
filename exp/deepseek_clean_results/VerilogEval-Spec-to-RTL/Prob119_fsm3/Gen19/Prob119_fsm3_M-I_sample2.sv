module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    // Gray code state encoding with D=3 for direct output
    parameter [1:0] A = 2'b00,
                    B = 2'b01,
                    C = 2'b10,
                    D = 2'b11;

    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
            out <= 1'b0;
        end else begin
            // synthesis parallel_case
            case (state)
                A: state <= in ? B : A;
                B: state <= in ? B : C;
                C: state <= in ? D : A;
                D: state <= in ? B : C;
            endcase
            
            // Output is MSB of state (D=11)
            out <= state[1] & state[0];
        end
    end

endmodule