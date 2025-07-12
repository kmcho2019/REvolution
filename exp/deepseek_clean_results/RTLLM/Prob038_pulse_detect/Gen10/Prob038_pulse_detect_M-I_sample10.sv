module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Optimized state encoding with 1 bit
localparam 
    IDLE   = 1'b0,
    GOT_0  = 1'b1;

reg state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                state <= (data_in == 0) ? GOT_0 : IDLE;
            end
            GOT_0: begin
                state <= (data_in == 1) ? IDLE : GOT_0;
            end
        endcase
    end
end

// Simplified combinational output logic
always @(*) begin
    data_out = (state == GOT_0) && (data_in == 0);
end

endmodule