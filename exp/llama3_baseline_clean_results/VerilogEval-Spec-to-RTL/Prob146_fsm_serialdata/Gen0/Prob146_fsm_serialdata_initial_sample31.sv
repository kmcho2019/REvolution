module TopModule (
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg [2:0] state;
reg [3:0] bit_count;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        bit_count <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // Idle
                if (!in) begin // Received start bit
                    state <= 1;
                    bit_count <= 0;
                end
            end
            1: begin // Start
                out_byte_reg[0] <= in;
                state <= 2;
            end
            2: begin // Data
                if (bit_count == 7) begin
                    out_byte_reg[7] <= in;
                    state <= 3;
                end else begin
                    out_byte_reg[bit_count + 1] <= in;
                    bit_count <= bit_count + 1;
                end
            end
            3: begin // Stop
                if (in) begin // Received stop bit
                    state <= 4;
                end
            end
            4: begin // Done
                done_reg <= 1;
                state <= 0;
            end
            default: state <= 0;
        endcase
    end
end

always @(posedge clk) begin
    out_byte <= out_byte_reg;
    done <= done_reg;
end

always @(posedge clk) begin
    if (state == 4) begin // Done
        done_reg <= 0;
    end
end

endmodule