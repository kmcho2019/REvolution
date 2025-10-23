module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Parameterized states with binary encoding
    parameter [1:0] A = 2'b00,
                    B = 2'b01,
                    C = 2'b10,
                    D = 2'b11;

    reg [1:0] state;

    // Single always block for sequential logic with clear transitions
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

    // Minimal combinational output logic
    assign out = (state == D);

endmodule