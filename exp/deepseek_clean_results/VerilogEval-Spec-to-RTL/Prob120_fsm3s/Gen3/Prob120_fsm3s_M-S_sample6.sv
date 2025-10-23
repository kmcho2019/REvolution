module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Define states as binary values
    parameter [1:0] A = 2'b00,
                    B = 2'b01,
                    C = 2'b10,
                    D = 2'b11;

    // State register
    reg [1:0] state;

    // Output logic
    assign out = (state == D);

    // Combined state transition and update logic
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

endmodule