module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg data_in_dly;
reg [1:0] state;

localparam IDLE  = 2'b00;
localparam DETECT = 2'b01;

wire rising_edge = ~data_in_dly & data_in;
wire falling_edge = data_in_dly & ~data_in;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_in_dly <= 1'b0;
        data_out <= 1'b0;
    end else begin
        data_in_dly <= data_in;
        
        case (state)
            IDLE: begin
                data_out <= 1'b0;
                if (rising_edge)
                    state <= DETECT;
            end
            DETECT: begin
                if (falling_edge) begin
                    state <= IDLE;
                    data_out <= 1'b1;
                end else begin
                    data_out <= 1'b0;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule