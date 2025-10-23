module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Gray-coded state encoding for reduced switching power
    reg [1:0] state;  // 00:A, 01:B, 11:C, 10:D

    // Combined state transition and update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;  // Reset to state A
        end else begin
            case (state)
                2'b00: state <= in ? 2'b01 : 2'b00;  // A -> B or A
                2'b01: state <= in ? 2'b01 : 2'b11;  // B -> B or C
                2'b11: state <= in ? 2'b10 : 2'b00;  // C -> D or A
                2'b10: state <= in ? 2'b01 : 2'b11;  // D -> B or C
            endcase
        end
    end

    // Simple output assignment (state D is 2'b10 in Gray coding)
    assign out = (state == 2'b10);

endmodule