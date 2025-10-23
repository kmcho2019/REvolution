module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to keep track of the state
parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= S0;
        data_out <= 0;
    end else begin
        case (state)
            S0: begin
                if (data_in == 0) begin
                    state <= S1;
                end else begin
                    state <= S0;
                end
                data_out <= 0;
            end
            S1: begin
                if (data_in == 1) begin
                    state <= S2;
                end else begin
                    state <= S1;
                end
                data_out <= 0;
            end
            S2: begin
                if (data_in == 0) begin
                    state <= S3;
                end else begin
                    state <= S2;
                end
                data_out <= 0;
            end
            S3: begin
                data_out <= 1;
                if (data_in == 0) begin
                    state <= S1;
                end else begin
                    state <= S0;
                end
            end
            default: begin
                state <= S0;
                data_out <= 0;
            end
        endcase
    end
end

endmodule