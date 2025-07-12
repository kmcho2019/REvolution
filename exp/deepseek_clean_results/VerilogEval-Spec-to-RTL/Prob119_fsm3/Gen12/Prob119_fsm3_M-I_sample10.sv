module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Gray coded state encoding (A=00, B=01, D=11, C=10)
    reg [1:0] state;

    // Combined state transition and update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00; // A
        end else begin
            case (state)
                2'b00: state <= in ? 2'b01 : 2'b00; // A->B or A->A
                2'b01: state <= in ? 2'b01 : 2'b10; // B->B or B->C
                2'b10: state <= in ? 2'b11 : 2'b00; // C->D or C->A
                2'b11: state <= in ? 2'b01 : 2'b10; // D->B or D->C
            endcase
        end
    end

    // Simple output assignment (state D = 2'b11)
    assign out = (state == 2'b11);

endmodule