module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Define state encoding
    parameter [1:0] A = 2'b00;
    parameter [1:0] B = 2'b01;
    parameter [1:0] C = 2'b10;
    parameter [1:0] D = 2'b11;

    // State register
    reg [1:0] state;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else begin
            case (state)
                A: state <= in ? B : A;
                B: state <= in ? B : C;
                C: state <= in ? D : A;
                D: state <= in ? B : C;
            endcase
        end
    end

    // Output logic
    assign out = (state == D);

endmodule