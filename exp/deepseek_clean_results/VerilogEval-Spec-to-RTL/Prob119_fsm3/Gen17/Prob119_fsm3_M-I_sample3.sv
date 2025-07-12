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
    wire clk_enable = (state != A) || (in != 0); // Simple clock gating condition

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
            out <= 0;
        end else if (clk_enable) begin
            case (state)
                A: state <= in ? B : A;
                B: state <= in ? B : C;
                C: state <= in ? D : A;
                D: state <= in ? B : C;
                default: state <= A;
            endcase
            
            // Registered output
            out <= (state == D);
        end
    end

endmodule