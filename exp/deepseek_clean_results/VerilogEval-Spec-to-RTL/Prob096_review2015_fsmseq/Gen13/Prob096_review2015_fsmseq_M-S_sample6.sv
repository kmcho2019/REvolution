module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [1:0] state;
    reg found;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            found <= 1'b0;
        end else if (!found) begin
            case (state)
                2'b00: state <= (data) ? 2'b01 : 2'b00;  // First '1'
                2'b01: state <= (data) ? 2'b10 : 2'b00;  // Second '1'
                2'b10: state <= (data) ? 2'b10 : 2'b11;  // '0' after '11'
                2'b11: begin
                    if (data) begin                      // Final '1' completes '1101'
                        found <= 1'b1;
                    end else begin
                        state <= 2'b00;                  // Reset if pattern breaks
                    end
                end
            endcase
        end
    end

    assign start_shifting = found;

endmodule