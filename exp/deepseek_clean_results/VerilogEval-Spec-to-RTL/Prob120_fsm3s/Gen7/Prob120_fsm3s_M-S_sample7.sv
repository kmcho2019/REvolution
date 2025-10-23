module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // Define state encoding
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    // State register
    reg [1:0] state;

    // Combined state transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            out <= 0;
        end
        else begin
            case (state)
                A: state <= in ? B : A;
                B: state <= in ? B : C;
                C: state <= in ? D : A;
                D: state <= in ? B : C;
            endcase
            out <= (state == D);
        end
    end

endmodule