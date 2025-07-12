module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [1:0] state;
reg [7:0] shift_reg;
reg [2:0] bit_counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00; // IDLE
        shift_reg <= 8'b0;
        bit_counter <= 3'b000;
        out_byte <= 8'b0;
        done <= 0;
    end
    else begin
        case(state)
            2'b00: begin // IDLE
                if (!in) begin
                    state <= 2'b01; // START
                end
            end
            2'b01: begin // START
                state <= 2'b10; // DATA
            end
            2'b10: begin // DATA
                shift_reg <= {in, shift_reg[7:1]};
                bit_counter <= bit_counter + 1;
                if (bit_counter == 3'd8) begin
                    state <= 2'b11; // STOP
                end
            end
            2'b11: begin // STOP
                if (in) begin
                    done <= 1;
                    out_byte <= shift_reg;
                end
                state <= 2'b00; // IDLE
            end
        endcase
    end
end

always @(posedge clk) begin
    if (state != 2'b11) begin // STOP
        done <= 0;
    end
end

endmodule