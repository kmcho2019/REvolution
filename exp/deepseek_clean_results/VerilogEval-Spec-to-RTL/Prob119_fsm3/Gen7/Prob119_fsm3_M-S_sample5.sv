module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    parameter A=0, B=1, C=2, D=3;
    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) state <= A;
        else case (state)
            A: state <= in ? B : A;
            B: state <= in ? B : C;
            C: state <= in ? D : A;
            D: state <= in ? B : C;
        endcase
    end

    assign out = (state == D);

endmodule