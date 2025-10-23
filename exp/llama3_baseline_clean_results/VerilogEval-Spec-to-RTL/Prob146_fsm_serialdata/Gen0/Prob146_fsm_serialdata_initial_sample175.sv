module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] byte;
reg [2:0] state; // 0: Idle, 1: Receive, 2: Verify
reg [2:0] bit_count;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        byte <= 8'b0;
        bit_count <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // Idle
                if (!in) begin
                    state <= 1;
                    bit_count <= 1;
                    byte[0] <= 1'b0; // LSB
                end
            end
            1: begin // Receive
                byte[bit_count] <= in;
                if (bit_count == 8'd8) begin
                    state <= 2;
                end else begin
                    bit_count <= bit_count + 1;
                end
            end
            2: begin // Verify
                if (in) begin
                    state <= 0;
                    done_reg <= 1;
                end // else, stay in Verify state until stop bit is detected
            end
            default: state <= 0;
        endcase
    end
end

assign out_byte = byte;
assign done = done_reg;

always @(posedge clk) begin
    if (state == 2) begin
        done_reg <= 0; // clear done signal for next cycle
    end
end

endmodule