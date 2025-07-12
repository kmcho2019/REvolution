module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output done
);

reg [1:0] state;
reg [1:0] nextState;
reg done_reg;

always @(*) begin
    case(state)
        2'b00: begin // IDLE
            if (in[3]) begin
                nextState = 2'b01; // BYTE1
            end else begin
                nextState = 2'b00; // stay in IDLE
            end
        end
        2'b01: begin // BYTE1
            nextState = 2'b10; // BYTE2
        end
        2'b10: begin // BYTE2
            nextState = 2'b11; // BYTE3
        end
        2'b11: begin // BYTE3
            nextState = 2'b00; // back to IDLE
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        done_reg <= 1'b0;
    end else begin
        state <= nextState;
        if (state == 2'b11) begin
            done_reg <= 1'b1;
        end else begin
            done_reg <= 1'b0;
        end
    end
end

assign done = done_reg;

endmodule