module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State encoding
localparam [1:0]
    IDLE   = 2'b00,
    SAW_0  = 2'b01,
    SAW_01 = 2'b10;

reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                data_out <= 0;
                state <= data_in ? IDLE : SAW_0;
            end
            SAW_0: begin
                data_out <= 0;
                state <= data_in ? SAW_01 : SAW_0;
            end
            SAW_01: begin
                data_out <= ~data_in; // Pulse detected only if we see 0
                state <= data_in ? IDLE : SAW_0;
            end
            default: begin
                data_out <= 0;
                state <= IDLE;
            end
        endcase
    end
end

endmodule