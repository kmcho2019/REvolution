module TopModule (
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

    reg [7:0] out_byte_reg;
    reg done_reg;
    reg [2:0] state; // 3 states: IDLE (3'b000), START (3'b001), DATA (3'b010), STOP (3'b011), ERROR (3'b100)
    reg [2:0] bit_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000; // IDLE
            done_reg <= 0;
            out_byte_reg <= 8'b0;
            bit_count <= 3'b000;
        end else begin
            case (state)
                3'b000: begin // IDLE
                    if (~in) begin // start bit detected
                        state <= 3'b001; // START
                        bit_count <= 3'b000;
                    end
                end
                3'b001: begin // START
                    state <= 3'b010; // DATA
                end
                3'b010: begin // DATA
                    out_byte_reg[bit_count] <= in; // store input bit
                    if (bit_count == 3'b111) begin
                        state <= 3'b011; // STOP
                    end else begin
                        bit_count <= bit_count + 1'b1;
                    end
                end
                3'b011: begin // STOP
                    if (in) begin // stop bit detected
                        done_reg <= 1;
                        state <= 3'b000; // IDLE
                        bit_count <= 3'b000;
                    end else begin
                        state <= 3'b100; // ERROR
                    end
                end
                3'b100: begin // ERROR
                    if (in) begin // stop bit detected
                        state <= 3'b000; // IDLE
                        bit_count <= 3'b000;
                    end
                end
                default: begin
                    state <= 3'b000; // IDLE
                end
            endcase
        end
    end

    always @(posedge clk) begin
        if (state == 3'b011 && in) begin // stop bit detected
            out_byte <= out_byte_reg; // output received byte
        end
    end

    always @(posedge clk) begin
        if (state == 3'b011 && in) begin // stop bit detected
            done <= 1; // assert done
        end else begin
            done <= 0; // deassert done
        end
    end

endmodule