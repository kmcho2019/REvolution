module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] shift_reg;
reg [2:0] state;
reg [3:0] bit_counter;
reg prev_in;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        shift_reg <= 8'b0;
        bit_counter <= 4'b0000;
        prev_in <= 1'b1;
    end else begin
        prev_in <= in;
        case(state)
            0: begin // IDLE
                if (!in && prev_in) begin // Falling edge detected
                    state <= 1;
                    bit_counter <= 4'b0001;
                    shift_reg[0] <= 1'b0; // Start bit
                end
            end
            1: begin // DATA
                if (bit_counter < 4'd8) begin
                    shift_reg <= {shift_reg[6:0], in};
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 4'd8) begin
                        state <= 2;
                    end
                end
            end
            2: begin // STOP
                if (in) begin // Stop bit verified
                    state <= 0;
                    done <= 1'b1;
                    out_byte <= shift_reg[7:0];
                end else begin
                    state <= 0; // Wait for stop bit
                end
            end
        endcase
    end
end

always @(negedge clk) begin
    done <= 1'b0;
end

endmodule