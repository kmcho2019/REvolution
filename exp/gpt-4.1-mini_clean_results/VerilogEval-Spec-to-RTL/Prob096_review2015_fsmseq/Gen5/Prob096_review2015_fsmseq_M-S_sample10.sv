module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            start_shifting <= 1'b0;
        end else begin
            case (state)
                2'b00: state <= data ? 2'b01 : 2'b00;
                2'b01: state <= data ? 2'b10 : 2'b00;
                2'b10: state <= data ? 2'b01 : 2'b11;
                2'b11: state <= data ? 2'b01 : 2'b00;
                default: state <= 2'b00;
            endcase

            if (state == 2'b11 && data)
                start_shifting <= 1'b1;
        end
    end

endmodule