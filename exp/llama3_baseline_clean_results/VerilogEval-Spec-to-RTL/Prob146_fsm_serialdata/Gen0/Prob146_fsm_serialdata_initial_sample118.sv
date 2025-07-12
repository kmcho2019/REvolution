module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] data;
reg [2:0] state; // 0: IDLE, 1: START_BIT, 2: DATA_BITS, 3: STOP_BIT, 4: ERROR
reg [2:0] counter;
reg [7:0] out_byte_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        counter <= 0;
        out_byte_reg <= 8'b0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin
                    state <= 1;
                    counter <= 1;
                    out_byte_reg[0] <= 1'b0;
                end
            end
            1: begin // START_BIT
                state <= 2;
            end
            2: begin // DATA_BITS
                out_byte_reg[7 - counter + 1] <= in;
                counter <= counter + 1;
                if (counter == 8) begin
                    state <= 3;
                    counter <= 0;
                end
            end
            3: begin // STOP_BIT
                if (in) begin
                    state <= 0;
                    counter <= 0;
                    out_byte <= out_byte_reg;
                    done <= 1'b1;
                end else begin
                    state <= 4; // ERROR
                end
            end
            4: begin // ERROR
                if (in) begin
                    state <= 0;
                    counter <= 0;
                end
            end
            default: begin
                state <= 0;
                counter <= 0;
            end
        endcase
    end
    if (state != 3) begin
        done <= 1'b0;
    end
end

endmodule