module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State encoding
localparam IDLE   = 2'b00;
localparam SAW_0  = 2'b01;
localparam SAW_01 = 2'b10;

reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                data_out <= 0;
                if (data_in == 0)
                    state <= SAW_0;
            end
            SAW_0: begin
                if (data_in == 1)
                    state <= SAW_01;
                else
                    state <= SAW_0;  // Stay if we see another 0
            end
            SAW_01: begin
                if (data_in == 0) begin
                    data_out <= 1;   // Complete 010 sequence
                    state <= IDLE;
                end else begin
                    state <= IDLE;    // Break sequence if we see 1
                end
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule