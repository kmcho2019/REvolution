module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;  // State A
            out <= 0;
        end else begin
            case (state)
                2'b00: state <= in ? 2'b01 : 2'b00;  // A -> B or A
                2'b01: state <= in ? 2'b01 : 2'b10;  // B -> B or C
                2'b10: state <= in ? 2'b11 : 2'b00;  // C -> D or A
                2'b11: state <= in ? 2'b01 : 2'b10;  // D -> B or C
            endcase
            out <= (state == 2'b11);  // Output 1 only in state D
        end
    end

endmodule