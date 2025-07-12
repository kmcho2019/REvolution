module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state;
reg [7:0] byte1, byte2, byte3;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Idle state
        done_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // Idle state
                if (in[3]) begin
                    byte1 <= in;
                    state <= 2'b01; // Byte1 state
                end
            end
            2'b01: begin // Byte1 state
                byte2 <= in;
                state <= 2'b10; // Byte2 state
            end
            2'b10: begin // Byte2 state
                byte3 <= in;
                state <= 2'b00; // Idle state
                done_reg <= 1'b1;
            end
            default: begin
                state <= 2'b00; // Idle state
            end
        endcase
    end
end

always @(posedge clk) begin
    done <= done_reg;
    if (reset) begin
        done_reg <= 1'b0;
    end else if (state == 2'b10) begin
        done_reg <= 1'b0;
    end
end

endmodule