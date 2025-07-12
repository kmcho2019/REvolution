module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [7:0] byte1, byte2, byte3;
reg [1:0] byte_count;
reg [23:0] out_bytes_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;  // IDLE state
        byte_count <= 0;
        out_bytes_reg <= 24'd0;
        done <= 0;
    end else begin
        case (state)
            0: begin  // IDLE state
                if (in[3] == 1) begin
                    state <= 1;  // transition to MSG_RECEIVE state
                    byte1 <= in;
                    byte_count <= 1;
                end
            end
            1: begin  // MSG_RECEIVE state
                case (byte_count)
                    1: begin
                        byte2 <= in;
                        byte_count <= 2;
                    end
                    2: begin
                        byte3 <= in;
                        byte_count <= 3;
                    end
                    3: begin
                        out_bytes_reg <= {byte1, byte2, byte3};
                        done <= 1;
                        state <= 0;  // transition back to IDLE state
                        byte_count <= 0;
                    end
                endcase
            end
        endcase
    end
end

always @(*) begin
    if (done) begin
        out_bytes <= out_bytes_reg;
    end else begin
        out_bytes <= 24'dx;  // don't care
    end
end

always @(posedge clk) begin
    if (done) begin
        done <= 0;  // clear done signal for the next cycle
    end
end

endmodule