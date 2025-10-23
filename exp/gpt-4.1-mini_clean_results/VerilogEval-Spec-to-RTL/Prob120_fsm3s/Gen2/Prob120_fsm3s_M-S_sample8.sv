module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;  // A
            out <= 1'b0;
        end else begin
            case (state)
                2'b00: begin // A
                    state <= in ? 2'b01 : 2'b00;
                    out <= 1'b0;
                end
                2'b01: begin // B
                    state <= in ? 2'b01 : 2'b10;
                    out <= 1'b0;
                end
                2'b10: begin // C
                    state <= in ? 2'b11 : 2'b00;
                    out <= 1'b0;
                end
                2'b11: begin // D
                    state <= in ? 2'b01 : 2'b10;
                    out <= 1'b1;
                end
                default: begin
                    state <= 2'b00;
                    out <= 1'b0;
                end
            endcase
        end
    end

endmodule