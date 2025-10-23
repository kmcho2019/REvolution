module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;

reg [2:0] state_reg;
reg [2:0] state_next;

reg [3:0] bit_counter_reg;
reg [3:0] bit_counter_next;

always @(*) begin
    case(state_reg)
        3'b000: begin // IDLE
            if (~in) begin
                state_next = 3'b001; // START_BIT
            end else begin
                state_next = 3'b000; // IDLE
            end
        end
        3'b001: begin // START_BIT
            state_next = 3'b010; // DATA_BITS
        end
        3'b010: begin // DATA_BITS
            if (bit_counter_reg == 4'd8) begin
                state_next = 3'b011; // STOP_BIT
            end else begin
                state_next = 3'b010; // DATA_BITS
            end
        end
        3'b011: begin // STOP_BIT
            if (in) begin
                state_next = 3'b100; // DONE
            end else begin
                state_next = 3'b011; // STOP_BIT
            end
        end
        3'b100: begin // DONE
            state_next = 3'b000; // IDLE
        end
        default: begin
            state_next = 3'b000; // IDLE
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 3'b000; // IDLE
        out_byte_reg <= 8'd0;
        done_reg <= 1'b0;
        bit_counter_reg <= 4'd0;
    end else begin
        state_reg <= state_next;
        case(state_reg)
            3'b010: begin // DATA_BITS
                out_byte_reg[bit_counter_reg] <= in;
                bit_counter_reg <= bit_counter_reg + 1;
            end
            3'b100: begin // DONE
                out_byte_reg <= out_byte_reg;
                done_reg <= 1'b1;
                bit_counter_reg <= 4'd0;
            end
            default: begin
                out_byte_reg <= out_byte_reg;
                done_reg <= 1'b0;
                bit_counter_reg <= bit_counter_reg;
            end
        endcase
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule