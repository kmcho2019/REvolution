module TopModule(
    input clk,
    input reset,
    input data,
    output start_shifting
);

parameter IDLE = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4;
reg [2:0] state;
reg start_shifting_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting_reg <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1) begin
                    state <= S1;
                end
            end
            S1: begin
                if (data == 1) begin
                    state <= S2;
                end else if (data == 0) begin
                    state <= IDLE;
                end
            end
            S2: begin
                if (data == 0) begin
                    state <= S3;
                end else if (data == 1) begin
                    state <= S1;
                end
            end
            S3: begin
                if (data == 1) begin
                    state <= S4;
                end else if (data == 0) begin
                    state <= IDLE;
                end
            end
            S4: begin
                start_shifting_reg <= 1;
            end
        endcase
    end
end

assign start_shifting = start_shifting_reg;

endmodule