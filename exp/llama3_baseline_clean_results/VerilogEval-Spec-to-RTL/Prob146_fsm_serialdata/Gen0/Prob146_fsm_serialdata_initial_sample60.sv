module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg; // 3 states: IDLE (0), START (1), DATA (2), STOP (3), INVALID (4)
reg [2:0] next_state;
reg [3:0] bit_count;

always @(*) begin
    case (state_reg)
        3'b000: next_state = (in == 1'b0)? 3'b001 : 3'b000; // IDLE
        3'b001: next_state = 3'b010; // START
        3'b010: begin
            if (bit_count == 4'd7) next_state = 3'b011; // DATA
            else next_state = 3'b010;
        end
        3'b011: next_state = (in == 1'b1)? 3'b100 : 3'b101; // STOP
        3'b100: next_state = 3'b000; // DONE
        3'b101: next_state = (in == 1'b1)? 3'b000 : 3'b101; // INVALID
        default: next_state = 3'b000;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 3'b000;
        out_byte_reg <= 8'b0;
        done_reg <= 1'b0;
        bit_count <= 4'b0;
    end else begin
        case (state_reg)
            3'b000: begin // IDLE
                out_byte_reg <= 8'b0;
                done_reg <= 1'b0;
                bit_count <= 4'b0;
            end
            3'b001: begin // START
                out_byte_reg <= 8'b0;
                done_reg <= 1'b0;
                bit_count <= 4'b0;
            end
            3'b010: begin // DATA
                out_byte_reg[bit_count] <= in;
                bit_count <= bit_count + 1'b1;
            end
            3'b011: begin // STOP
                done_reg <= 1'b1;
            end
            3'b100: begin // DONE
                done_reg <= 1'b0;
            end
            3'b101: begin // INVALID
                // wait until stop bit is detected
            end
        endcase
        state_reg <= next_state;
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule