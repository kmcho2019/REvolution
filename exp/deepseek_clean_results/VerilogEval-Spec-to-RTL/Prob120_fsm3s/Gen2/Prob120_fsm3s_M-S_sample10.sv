module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // Define states with minimal encoding
    reg [1:0] state;
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

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