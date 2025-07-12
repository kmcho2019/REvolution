module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    // State encoding with parameters for clarity
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    reg [1:0] state;

    // Optimized state transition logic with single always block
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
            out <= 1'b0;
        end else begin
            case (state)
                A: state <= in ? B : A;
                B: state <= in ? B : C;
                C: state <= in ? D : A;
                D: state <= in ? B : C;
            endcase
            
            // Registered output
            out <= (state == D);
        end
    end

endmodule