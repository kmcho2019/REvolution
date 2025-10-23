module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg; // 3 states: IDLE (0), RECEIVE_BYTE (1), STOP_BIT (2), ERROR (3, 4, 5, 6, 7)
reg [2:0] next_state;

always @(*) begin
    case(state_reg)
        3'b000: begin // IDLE
            if (~in) begin
                next_state = 3'b001;
            end else begin
                next_state = 3'b000;
            end
        end
        3'b001: begin // RECEIVE_BYTE
            if (out_byte_reg == 8'b11111111) begin
                next_state = 3'b010;
            end else begin
                next_state = 3'b001;
            end
        end
        3'b010: begin // STOP_BIT
            if (in) begin
                next_state = 3'b000;
            end else begin
                next_state = 3'b011;
            end
        end
        3'b011: begin // ERROR
            if (in) begin
                next_state = 3'b000;
            end else begin
                next_state = 3'b011;
            end
        end
        default: begin
            next_state = 3'b000;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 3'b000;
        out_byte_reg <= 8'b00000000;
        done_reg <= 1'b0;
    end else begin
        case(state_reg)
            3'b000: begin // IDLE
                if (~in) begin
                    out_byte_reg <= 8'b00000000;
                    state_reg <= 3'b001;
                end else begin
                    state_reg <= 3'b000;
                end
            end
            3'b001: begin // RECEIVE_BYTE
                out_byte_reg <= {out_byte_reg[6:0], in};
                if (out_byte_reg == 8'b11111111) begin
                    state_reg <= 3'b010;
                end else begin
                    state_reg <= 3'b001;
                end
            end
            3'b010: begin // STOP_BIT
                if (in) begin
                    done_reg <= 1'b1;
                    state_reg <= 3'b000;
                end else begin
                    state_reg <= 3'b011;
                end
            end
            3'b011: begin // ERROR
                if (in) begin
                    state_reg <= 3'b000;
                end else begin
                    state_reg <= 3'b011;
                end
            end
            default: begin
                state_reg <= 3'b000;
            end
        endcase
        if (state_reg == 3'b010 && in) begin
            done_reg <= 1'b1;
        end else begin
            done_reg <= 1'b0;
        end
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule