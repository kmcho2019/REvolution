module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT, 3: DONE
reg [3:0] shift_reg;
reg [3:0] delay;
reg [11:0] counter;
reg counting_reg;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        shift_reg <= 0;
        delay <= 0;
        counter <= 0;
        counting_reg <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data == 1) begin
                    shift_reg <= {shift_reg[2:0], 1};
                    if (shift_reg == 4'b1101) begin
                        state <= 1;
                    end
                end else if (data == 0) begin
                    shift_reg <= {shift_reg[2:0], 0};
                end
            end
            1: begin // SHIFT
                shift_reg <= {shift_reg[2:0], data};
                if (&shift_reg[3:0]) begin // all bits have been shifted in
                    delay <= shift_reg;
                    state <= 2;
                    counter <= ((delay + 1) * 1000) - 1;
                    counting_reg <= 1;
                end
            end
            2: begin // COUNT
                if (counter == 0) begin
                    state <= 3;
                    counting_reg <= 0;
                    done_reg <= 1;
                end else begin
                    counter <= counter - 1;
                    count <= delay - (999 - counter[11:3]);
                end
            end
            3: begin // DONE
                if (ack) begin
                    state <= 0;
                    done_reg <= 0;
                end
            end
        endcase
    end
end

assign count = (state == 2) ? delay - (999 - counter[11:3]) : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule