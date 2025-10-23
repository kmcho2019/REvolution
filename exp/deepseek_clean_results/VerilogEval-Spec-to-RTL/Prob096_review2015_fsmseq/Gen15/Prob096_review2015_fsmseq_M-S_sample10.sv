module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    reg [1:0] state;

    // State encoding:
    // 00: No match
    // 01: First '1' matched
    // 10: '11' matched
    // 11: '110' matched (next '1' will complete the sequence)

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            start_shifting <= 1'b0;
        end else if (!start_shifting) begin
            case (state)
                2'b00: state <= data ? 2'b01 : 2'b00;
                2'b01: state <= data ? 2'b10 : 2'b00;
                2'b10: state <= data ? 2'b10 : 2'b11;
                2'b11: begin
                    if (data) begin
                        start_shifting <= 1'b1;
                        state <= 2'b00;
                    end else begin
                        state <= 2'b00;
                    end
                end
            endcase
        end
    end

endmodule