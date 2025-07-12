module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

reg [1:0] state; // 2 bits to represent the 4 states (00, 01, 10, 11)
reg start_shifting_reg;

// Initialize the state and output
initial begin
    state = 2'b00; // IDLE state
    start_shifting_reg = 1'b0;
end

always @ (posedge clk) begin
    if (reset) begin // active high synchronous reset
        state = 2'b00; // reset state to IDLE
        start_shifting_reg = 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (data == 1'b1) begin
                    state = 2'b01; // STATE_1
                end
            end
            2'b01: begin // STATE_1
                if (data == 1'b1) begin
                    state = 2'b10; // STATE_11
                end else if (data == 1'b0) begin
                    state = 2'b00; // back to IDLE
                end
            end
            2'b10: begin // STATE_11
                if (data == 1'b0) begin
                    state = 2'b11; // STATE_110
                end else if (data == 1'b1) begin
                    state = 2'b10; // stay in STATE_11
                end
            end
            2'b11: begin // STATE_110
                if (data == 1'b1) begin
                    state = 2'b11; // stay in STATE_110
                    start_shifting_reg = 1'b1; // FOUND
                end else begin
                    state = 2'b00; // back to IDLE
                end
            end
            default: state = 2'b00;
        endcase
    end
end

assign start_shifting = start_shifting_reg;

endmodule