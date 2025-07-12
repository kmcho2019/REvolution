module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state;
reg [7:0] shift_reg;
reg [3:0] bit_counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000; // IDLE state
        shift_reg <= 8'b0;
        bit_counter <= 4'b0;
        out_byte <= 8'b0;
        done <= 0;
    end else begin
        case (state)
            3'b000: begin // IDLE state
                if (!in) begin // Start bit detected
                    state <= 3'b001; // RECEIVE state
                    bit_counter <= 1;
                    shift_reg <= {7'b0, in};
                end
            end
            3'b001: begin // RECEIVE state
                shift_reg <= {in, shift_reg[7:1]}; // Shift new bit into the most significant position
                bit_counter <= bit_counter + 1;
                if (bit_counter == 4'd8) begin // Complete byte received
                    if (in) begin // Stop bit detected
                        out_byte <= shift_reg;
                        done <= 1;
                    end
                    state <= 3'b000; // IDLE state
                end
            end
        endcase
        if (state != 3'b001 || bit_counter != 4'd8) begin
            done <= 0;
        end
    end
end

endmodule