module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state;
reg [7:0] shift_reg;
reg [2:0] bit_counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000; // WAIT_START
        shift_reg <= 8'b0;
        bit_counter <= 3'b000;
        out_byte <= 8'b0;
        done <= 0;
    end
    else begin
        case(state)
            3'b000: begin // WAIT_START
                if (!in) begin
                    state <= 3'b001; // RECEIVE_DATA
                    bit_counter <= 3'b001;
                    shift_reg <= {7'b0, in};
                end
            end
            3'b001: begin // RECEIVE_DATA
                shift_reg <= {in, shift_reg[7:1]};
                bit_counter <= bit_counter + 1;
                if (bit_counter == 3'b100) begin
                    state <= 3'b010; // CHECK_STOP
                end
            end
            3'b010: begin // CHECK_STOP
                if (in) begin
                    done <= 1;
                    out_byte <= shift_reg;
                    state <= 3'b000; // WAIT_START
                end
                else begin
                    state <= 3'b011; // WAIT_STOP
                end
            end
            3'b011: begin // WAIT_STOP
                if (in) begin
                    state <= 3'b000; // WAIT_START
                end
            end
            default: begin
                state <= 3'b000; // WAIT_START
            end
        endcase
        if (state != 3'b010) begin
            done <= 0;
        end
    end
end

endmodule