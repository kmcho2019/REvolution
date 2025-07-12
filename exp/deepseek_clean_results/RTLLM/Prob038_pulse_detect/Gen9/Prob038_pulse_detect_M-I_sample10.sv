module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Optimized state encoding with 2 states + output
localparam [1:0] 
    IDLE   = 2'b00,
    GOT_0  = 2'b01,
    PULSE  = 2'b10;

reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                data_out <= 1'b0;
                state <= (data_in == 0) ? GOT_0 : IDLE;
            end
            GOT_0: begin
                data_out <= 1'b0;
                if (data_in == 1)
                    state <= PULSE;
                else
                    state <= GOT_0;  // stay in GOT_0 if we get another 0
            end
            PULSE: begin
                data_out <= (data_in == 0);  // output 1 only if we complete 0->1->0
                state <= (data_in == 0) ? GOT_0 : IDLE;
            end
            default: begin
                data_out <= 1'b0;
                state <= IDLE;
            end
        endcase
    end
end

endmodule