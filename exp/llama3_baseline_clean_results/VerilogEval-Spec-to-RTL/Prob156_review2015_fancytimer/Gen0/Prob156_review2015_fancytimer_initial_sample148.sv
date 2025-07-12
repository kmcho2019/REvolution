module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] shift_reg;
reg [3:0] delay;
reg [3:0] counter;
reg [9:0] timer_counter;
reg counting_reg;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 0;
        delay <= 0;
        counter <= 0;
        timer_counter <= 0;
        counting_reg <= 0;
        done_reg <= 0;
    end else begin
        case ({shift_reg[3], shift_reg[2], shift_reg[1], shift_reg[0]})
            4'b1101: begin
                // load delay
                if (!counting_reg) begin
                    shift_reg <= {shift_reg[2:0], data};
                end else begin
                    delay[3] <= data;
                    shift_reg <= {shift_reg[2:0], 0};
                    counting_reg <= 1;
                end
            end
            4'b1100: begin
                delay[2] <= shift_reg[0];
                shift_reg <= {shift_reg[2:0], data};
            end
            4'b110: begin
                delay[1] <= shift_reg[0];
                shift_reg <= {shift_reg[2:0], data};
            end
            4'b11: begin
                delay[0] <= shift_reg[0];
                shift_reg <= {shift_reg[2:0], data};
            end
            default: begin
                if (data == 1) begin
                    shift_reg <= {shift_reg[2:0], data};
                end
            end
        endcase
        
        if (counting_reg) begin
            if (timer_counter == (delay + 1) * 1000 - 1) begin
                if (counter > 0) begin
                    counter <= counter - 1;
                    timer_counter <= 0;
                end else begin
                    counting_reg <= 0;
                    done_reg <= 1;
                end
            end else begin
                timer_counter <= timer_counter + 1;
            end
        end
        
        if (done_reg && ack) begin
            done_reg <= 0;
        end
    end
end

assign count = counting_reg ? delay - counter : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule