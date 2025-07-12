module TopModule(
    input clk,
    input reset,
    input data,
    output start_shifting
);

reg [2:0] state;
reg start_shifting_reg;

always @ (posedge clk) begin
    if (reset) begin
        state <= 3'b000; // IDLE state
        start_shifting_reg <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // IDLE state
                if (data) begin
                    state <= 3'b001; // GOT_1 state
                end else begin
                    state <= 3'b000; // stay in IDLE state
                end
            end
            3'b001: begin // GOT_1 state
                if (data) begin
                    state <= 3'b010; // GOT_11 state
                end else begin
                    state <= 3'b000; // back to IDLE state
                end
            end
            3'b010: begin // GOT_11 state
                if (data) begin
                    state <= 3'b010; // stay in GOT_11 state
                end else begin
                    state <= 3'b011; // GOT_110 state
                end
            end
            3'b011: begin // GOT_110 state
                if (data) begin
                    state <= 3'b100; // FOUND state
                    start_shifting_reg <= 1'b1;
                end else begin
                    state <= 3'b000; // back to IDLE state
                end
            end
            3'b100: begin // FOUND state
                // stay in FOUND state and keep start_shifting high
            end
        endcase
    end
end

assign start_shifting = start_shifting_reg;

endmodule