module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
        end else begin
            case (state)
                2'b00: state <= (data) ? 2'b01 : 2'b00;  // First '1'
                2'b01: state <= (data) ? 2'b10 : 2'b00;  // Second '1'
                2'b10: state <= (data) ? 2'b10 : 2'b11;  // '0' after '11'
                2'b11: state <= (data) ? 2'b01 : 2'b00;  // Final '1' (match)
                default: state <= 2'b00;
            endcase
        end
    end

    assign start_shifting = (state == 2'b11);

endmodule