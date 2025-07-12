module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State encoding
localparam IDLE   = 2'b00;
localparam GOT_1  = 2'b01;
localparam GOT_10 = 2'b10;

reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                data_out <= 1'b0;
                if (data_in) state <= GOT_1;
            end
            GOT_1: begin
                data_out <= 1'b0;
                if (!data_in) state <= GOT_10;
                else state <= GOT_1; // Stay if input remains 1
            end
            GOT_10: begin
                data_out <= 1'b1; // Pulse detected
                if (data_in) state <= GOT_1;
                else state <= IDLE;
            end
            default: begin
                state <= IDLE;
                data_out <= 1'b0;
            end
        endcase
    end
end

endmodule