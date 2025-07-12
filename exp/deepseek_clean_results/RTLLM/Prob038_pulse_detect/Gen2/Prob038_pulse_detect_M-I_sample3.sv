module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states using one-hot encoding (better for synthesis)
localparam IDLE  = 2'b00;
localparam GOT_0 = 2'b01;
localparam GOT_1 = 2'b10;

reg [1:0] state;

// Combined state and output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        casez (state)
            IDLE: begin
                state <= (data_in == 0) ? GOT_0 : IDLE;
                data_out <= 0;
            end
            GOT_0: begin
                state <= (data_in == 1) ? GOT_1 : GOT_0;
                data_out <= 0;
            end
            GOT_1: begin
                if (data_in == 0) begin
                    state <= IDLE;
                    data_out <= 1;
                end else begin
                    state <= GOT_1;
                    data_out <= 0;
                end
            end
        endcase
    end
end

endmodule