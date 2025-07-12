module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state;
reg [1:0] byte_count;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE state
        byte_count <= 2'b00;
        done_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3]) begin
                    state <= 2'b01; // RECEIVING_MESSAGE state
                    byte_count <= 2'b01;
                end else begin
                    state <= 2'b00; // Stay in IDLE state
                    byte_count <= 2'b00;
                end
                done_reg <= 1'b0;
            end
            2'b01: begin // RECEIVING_MESSAGE state
                byte_count <= byte_count + 1'b1;
                if (byte_count == 2'b11) begin
                    state <= 2'b00; // Transition back to IDLE state
                    byte_count <= 2'b00;
                    done_reg <= 1'b1;
                end else begin
                    state <= 2'b01; // Stay in RECEIVING_MESSAGE state
                end
            end
            default: begin
                state <= 2'b00; // Default to IDLE state
                byte_count <= 2'b00;
                done_reg <= 1'b0;
            end
        endcase
    end
end

assign done = done_reg;

endmodule