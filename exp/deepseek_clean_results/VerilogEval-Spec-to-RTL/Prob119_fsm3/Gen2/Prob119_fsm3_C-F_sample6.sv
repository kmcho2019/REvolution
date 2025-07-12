module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Define states using Gray coding for minimal transitions
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b11;
    parameter D = 2'b10;

    // State register
    reg [1:0] state;

    // State transition and reset logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
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

    // Output logic (Moore: output depends only on state)
    assign out = (state == D);

endmodule