module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

reg [1:0] state;
reg start_shifting_reg;

always @ (posedge clk) begin
    if (reset) begin
        state <= 0;
        start_shifting_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data) begin
                    state <= 1; // S1
                end
            end
            1: begin // S1
                if (data) begin
                    state <= 2; // S2
                end else begin
                    state <= 0; // IDLE
                end
            end
            2: begin // S2
                if (!data) begin
                    state <= 3; // S3
                end else begin
                    state <= 1; // S1
                end
            end
            3: begin // S3
                if (data) begin
                    state <= 4; // FOUND
                end else begin
                    state <= 0; // IDLE
                end
            end
            4: begin // FOUND
                start_shifting_reg <= 1;
            end
        endcase
    end
end

assign start_shifting = start_shifting_reg;

endmodule