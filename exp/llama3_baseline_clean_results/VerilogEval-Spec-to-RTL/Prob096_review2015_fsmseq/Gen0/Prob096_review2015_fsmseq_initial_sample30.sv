module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

reg [1:0] state;
reg start_shifting_reg;

always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00;  // IDLE state
        start_shifting_reg <= 1'b0;
    end else begin
        case(state)
            2'b00: begin  // IDLE
                if(data) begin
                    state <= 2'b01;  // S1
                end
            end
            2'b01: begin  // S1
                if(data) begin
                    state <= 2'b10;  // S2
                end else begin
                    state <= 2'b00;  // IDLE
                end
            end
            2'b10: begin  // S2
                if(!data) begin
                    state <= 2'b11;  // S3
                end else begin
                    state <= 2'b00;  // IDLE
                end
            end
            2'b11: begin  // S3
                if(data) begin
                    state <= 2'b11;  // FOUND
                    start_shifting_reg <= 1'b1;
                end else begin
                    state <= 2'b00;  // IDLE
                end
            end
            default: begin  // FOUND
                state <= 2'b11;  // Stay in FOUND state
            end
        endcase
    end
end

assign start_shifting = start_shifting_reg;

endmodule