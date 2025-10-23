module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state; // IDLE (3'b000), START (3'b001), DATA (3'b010), STOP (3'b011), ERROR (3'b100)
reg [2:0] data_bit_counter;

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // IDLE
        out_byte_reg <= 8'b0;
        done_reg <= 1'b0;
        data_bit_counter <= 3'b000;
    end else begin
        case (state)
            3'b000: begin // IDLE
                if (~in) begin // Start bit detected
                    state <= 3'b001; // START
                    out_byte_reg <= 8'b0;
                    data_bit_counter <= 3'b000;
                end
            end
            3'b001: begin // START
                state <= 3'b010; // DATA
            end
            3'b010: begin // DATA
                out_byte_reg[7 - data_bit_counter] <= in;
                if (data_bit_counter == 3'b111) begin
                    state <= 3'b011; // STOP
                end else begin
                    data_bit_counter <= data_bit_counter + 1'b1;
                end
            end
            3'b011: begin // STOP
                if (in) begin // Correct stop bit
                    state <= 3'b000; // IDLE
                    done_reg <= 1'b1;
                end else begin
                    state <= 3'b100; // ERROR
                end
            end
            3'b100: begin // ERROR
                if (in) begin // Stop bit detected
                    state <= 3'b000; // IDLE
                end
            end
        endcase
        if (state == 3'b000 && ~reset) begin
            done_reg <= 1'b0;
        end
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule