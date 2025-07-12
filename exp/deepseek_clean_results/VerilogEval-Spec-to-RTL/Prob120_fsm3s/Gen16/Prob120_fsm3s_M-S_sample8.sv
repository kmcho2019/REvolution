module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
        end else begin
            case (state)
                2'b00: state <= in ? 2'b01 : 2'b00;  // A
                2'b01: state <= in ? 2'b01 : 2'b10;  // B
                2'b10: state <= in ? 2'b11 : 2'b00;  // C
                2'b11: state <= in ? 2'b01 : 2'b10;  // D
            endcase
        end
    end

    assign out = (state == 2'b11);

endmodule