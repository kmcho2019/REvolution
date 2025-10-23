module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State encoding
localparam IDLE  = 2'b00;
localparam GOT_0 = 2'b01;
localparam GOT_1 = 2'b10;

reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                data_out <= 1'b0;
                if (!data_in) state <= GOT_0;
            end
            GOT_0: begin
                data_out <= 1'b0;
                if (data_in) state <= GOT_1;
                else state <= GOT_0;  // Stay if we get consecutive 0s
            end
            GOT_1: begin
                if (!data_in) begin
                    data_out <= 1'b1;
                    state <= IDLE;
                end else begin
                    data_out <= 1'b0;
                    state <= GOT_1;  // Stay if we get consecutive 1s
                end
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule