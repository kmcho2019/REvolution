module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;
            out <= 0;
        end
        else case (state)
            2'b00: state <= in ? 2'b01 : 2'b00;
            2'b01: state <= in ? 2'b01 : 2'b10;
            2'b10: state <= in ? 2'b11 : 2'b00;
            2'b11: state <= in ? 2'b01 : 2'b10;
        endcase
        out <= (state == 2'b11);
    end

endmodule