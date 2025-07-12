module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State encoding with descriptive names
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    reg [1:0] state;

    // Combined state transition and storage with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            case (state)
                A: state <= in ? B : A;
                B: state <= in ? B : C;
                C: state <= in ? D : A;
                D: state <= in ? B : C;
                default: state <= A;  // Safety catch-all
            endcase
        end
    end

    // Simple Moore output logic
    assign out = (state == D);

endmodule