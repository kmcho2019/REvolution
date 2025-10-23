module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg [1:0] state = 2'b00; // Default to state A (00)

    always @(posedge clk or posedge areset) begin
        if (areset) state <= 2'b00;
        else case (state)
            2'b00: state <= in ? 2'b01 : 2'b00; // A
            2'b01: state <= in ? 2'b01 : 2'b10; // B
            2'b10: state <= in ? 2'b11 : 2'b00; // C
            2'b11: state <= in ? 2'b01 : 2'b10; // D
        endcase
    end

    assign out = (state == 2'b11); // Output 1 when in state D

endmodule