module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg; // 0: IDLE, 1: START, 2: DATA, 3: STOP, 4: DONE
reg [3:0] counter_reg;

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 0; // IDLE
        counter_reg <= 0;
        out_byte_reg <= 8'b0;
        done_reg <= 0;
    end else begin
        case (state_reg)
            0: begin // IDLE
                if (!in) begin // start bit detected
                    state_reg <= 1; // START
                end
            end
            1: begin // START
                state_reg <= 2; // DATA
            end
            2: begin // DATA
                out_byte_reg[7 - counter_reg] <= in;
                counter_reg <= counter_reg + 1;
                if (counter_reg == 8) begin
                    state_reg <= 3; // STOP
                    counter_reg <= 0;
                end
            end
            3: begin // STOP
                if (in) begin // stop bit detected
                    state_reg <= 4; // DONE
                    done_reg <= 1;
                end
            end
            4: begin // DONE
                state_reg <= 0; // IDLE
                done_reg <= 0;
            end
        endcase
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule