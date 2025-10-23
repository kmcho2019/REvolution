module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state;
reg output_bit;
reg seen_one;

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
        seen_one <= 1'b0;
        output_bit <= 1'b0;
    end else begin
        case(state)
            2'b00: begin // idle state, waiting for first input
                if (~x) begin
                    state <= 2'b01;
                    seen_one <= 1'b1;
                    output_bit <= 1'b1;
                end else begin
                    state <= 2'b01;
                    seen_one <= 1'b0;
                    output_bit <= 1'b0;
                end
            end
            2'b01: begin // active state, producing output
                if (~seen_one) begin
                    if (~x) begin
                        seen_one <= 1'b1;
                    end
                    output_bit <= ~x;
                end else begin
                    output_bit <= ~x;
                end
            end
        endcase
    end
end

assign z = output_bit;

endmodule