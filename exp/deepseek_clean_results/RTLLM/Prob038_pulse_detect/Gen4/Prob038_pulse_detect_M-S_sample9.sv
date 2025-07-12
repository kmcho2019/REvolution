module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Simplified state encoding
reg state;  // 0: IDLE, 1: GOT_01

always @(posedge clk) begin
    if (!rst_n) begin
        state <= 0;
        data_out <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                state <= (data_in == 0);
                data_out <= 0;
            end
            1: begin // GOT_01
                state <= (data_in == 1);
                data_out <= (data_in == 0);
            end
        endcase
    end
end

endmodule