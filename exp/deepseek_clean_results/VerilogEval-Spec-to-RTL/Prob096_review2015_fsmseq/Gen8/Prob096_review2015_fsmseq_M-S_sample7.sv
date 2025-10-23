module TopModule (
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
        end else if (!start_shifting) begin
            case (state)
                2'b00: state <= (data) ? 2'b01 : 2'b00;  // First '1'
                2'b01: state <= (data) ? 2'b10 : 2'b00;  // Second '1'
                2'b10: state <= (data) ? 2'b10 : 2'b11;  // '0' after '11'
                2'b11: begin
                    start_shifting <= data;  // Final '1' completes "1101"
                    state <= data ? 2'b11 : 2'b00;
                end
            endcase
        end
    end

endmodule