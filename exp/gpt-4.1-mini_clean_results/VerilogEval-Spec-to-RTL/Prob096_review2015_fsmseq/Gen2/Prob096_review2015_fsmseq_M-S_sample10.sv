module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    reg [1:0] state;

    // State encoding:
    // 0: no match
    // 1: matched '1'
    // 2: matched '11'
    // 3: matched '110'

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            start_shifting <= 1'b0;
        end else begin
            if (!start_shifting) begin
                case (state)
                    2'b00: state <= data ? 2'b01 : 2'b00;
                    2'b01: state <= data ? 2'b10 : 2'b00;
                    2'b10: state <= data ? 2'b10 : 2'b11;
                    2'b11: state <= data ? 2'b01 : 2'b00;
                endcase
                // Check sequence detection
                if (state == 2'b11 && data == 1'b1)
                    start_shifting <= 1'b1;
            end
        end
    end

endmodule