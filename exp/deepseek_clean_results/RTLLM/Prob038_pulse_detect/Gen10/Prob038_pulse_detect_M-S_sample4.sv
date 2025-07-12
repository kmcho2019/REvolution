module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00;
        data_out <= 1'b0;
    end else begin
        case (state)
            2'b00: begin
                data_out <= 1'b0;
                if (data_in == 1'b0)
                    state <= 2'b01;
            end
            2'b01: begin
                data_out <= 1'b0;
                if (data_in == 1'b1)
                    state <= 2'b10;
                else if (data_in == 1'b0)
                    state <= 2'b01;
            end
            2'b10: begin
                if (data_in == 1'b0) begin
                    data_out <= 1'b1;
                    state <= 2'b00;
                end else begin
                    data_out <= 1'b0;
                    state <= 2'b00;
                end
            end
            default: state <= 2'b00;
        endcase
    end
end

endmodule