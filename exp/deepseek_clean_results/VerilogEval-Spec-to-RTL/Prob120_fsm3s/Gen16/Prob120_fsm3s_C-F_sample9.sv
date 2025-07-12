module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Gray code state encoding: A=00, B=01, D=11, C=10
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter D = 2'b11;
    parameter C = 2'b10;

    reg [1:0] state;

    // Next state logic with Gray code transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end else begin
            case (state)
                A: state <= in ? B : A;
                B: state <= in ? B : C;
                C: state <= in ? D : A;
                D: state <= in ? B : C;
            endcase
        end
    end

    // Output is high only in state D (11)
    assign out = (state == D);

endmodule