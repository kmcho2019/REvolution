module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // Define states using Gray code encoding
    parameter [1:0] A = 2'b00,
                    B = 2'b01,
                    C = 2'b11,
                    D = 2'b10;

    // State register
    reg [1:0] state;

    // Combined state transition, update, and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            out <= 1'b0;
        end
        else begin
            case (state)
                A: begin
                    state <= in ? B : A;
                    out <= 1'b0;
                end
                B: begin
                    state <= in ? B : C;
                    out <= 1'b0;
                end
                C: begin
                    state <= in ? D : A;
                    out <= 1'b0;
                end
                D: begin
                    state <= in ? B : C;
                    out <= 1'b1;
                end
            endcase
        end
    end

endmodule