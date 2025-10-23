module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg data_in_dly;
reg [1:0] state;

localparam IDLE     = 2'b00;
localparam GOT_RISE = 2'b01;
localparam GOT_FALL = 2'b10;

wire rising_edge = ~data_in_dly & data_in;
wire falling_edge = data_in_dly & ~data_in;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_in_dly <= 1'b0;
        data_out <= 1'b0;
    end else begin
        data_in_dly <= data_in;
        data_out <= 1'b0;  // Default output
        
        case (state)
            IDLE: begin
                if (rising_edge && !data_in_dly)  // Only if previous was 0
                    state <= GOT_RISE;
            end
            GOT_RISE: begin
                if (falling_edge)
                    state <= GOT_FALL;
                else if (!data_in)  // If we get back to 0 without proper sequence
                    state <= IDLE;
            end
            GOT_FALL: begin
                data_out <= 1'b1;    // Pulse detected
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule