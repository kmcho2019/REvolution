module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg; // idle (0), start (1), data (2), stop (3)
reg [2:0] next_state;
reg [7:0] data_reg;
reg [3:0] bit_counter;

always @(*) begin
    case(state_reg)
        3'b000: begin // idle
            if (~in) begin // start bit detected
                next_state = 3'b001; // transition to start state
            end else begin
                next_state = 3'b000; // stay in idle state
            end
        end
        3'b001: begin // start
            next_state = 3'b010; // transition to data state
        end
        3'b010: begin // data
            if (bit_counter == 4'd8) begin // all data bits collected
                next_state = 3'b011; // transition to stop state
            end else begin
                next_state = 3'b010; // stay in data state
            end
        end
        3'b011: begin // stop
            next_state = 3'b000; // transition to idle state
        end
        default: next_state = 3'b000; // default to idle state
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 3'b000; // reset to idle state
        out_byte_reg <= 8'b0;
        done_reg <= 1'b0;
        data_reg <= 8'b0;
        bit_counter <= 4'b0;
    end else begin
        state_reg <= next_state;
        case(state_reg)
            3'b010: begin // data
                data_reg <= {data_reg[6:0], in}; // shift in data bit
                bit_counter <= bit_counter + 1'b1; // increment bit counter
            end
            3'b011: begin // stop
                if (in) begin // stop bit verified
                    out_byte_reg <= data_reg;
                    done_reg <= 1'b1;
                end else begin // stop bit not verified
                    out_byte_reg <= 8'b0;
                    done_reg <= 1'b0;
                end
            end
            default: begin
                out_byte_reg <= 8'b0;
                done_reg <= 1'b0;
                data_reg <= 8'b0;
                bit_counter <= 4'b0;
            end
        endcase
    end
end

assign out_byte = out_byte_reg;
assign done = (state_reg == 3'b011) && in;

endmodule