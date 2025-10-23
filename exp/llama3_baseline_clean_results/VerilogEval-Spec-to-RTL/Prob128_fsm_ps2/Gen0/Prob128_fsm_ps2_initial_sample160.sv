module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // 0: idle, 1: receiving, 2: done
reg [1:0] byte_count;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        byte_count <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (in[3]) begin
                    state <= 1;
                    byte_count <= 1;
                end
            end
            1: begin // receiving
                byte_count <= byte_count + 1;
                if (byte_count == 3) begin
                    state <= 2;
                end
            end
            2: begin // done
                done_reg <= 1;
                state <= 0;
            end
            default: state <= 0;
        endcase
    end
end

assign done = done_reg;

always @(posedge clk) begin
    if (~reset) begin
        done_reg <= 0;
    end
end

endmodule