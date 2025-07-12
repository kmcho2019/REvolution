module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg state;

localparam IDLE = 1'b0;
localparam GOT_RISE = 1'b1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                data_out <= 1'b0;
                if (data_in) state <= GOT_RISE;  // 0->1 transition
            end
            GOT_RISE: begin
                data_out <= ~data_in;  // 1 when falling edge (1->0)
                state <= data_in ? GOT_RISE : IDLE;
            end
        endcase
    end
end

endmodule