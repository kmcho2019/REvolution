module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [1:0] state;
    reg matched;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            matched <= 1'b0;
        end else if (!matched) begin
            case (state)
                2'b00: state <= data ? 2'b01 : 2'b00;
                2'b01: state <= data ? 2'b10 : 2'b00;
                2'b10: state <= data ? 2'b10 : 2'b11;
                2'b11: begin
                    if (data) begin
                        matched <= 1'b1;
                    end else begin
                        state <= 2'b00;
                    end
                end
            endcase
        end
    end

    assign start_shifting = matched;

endmodule