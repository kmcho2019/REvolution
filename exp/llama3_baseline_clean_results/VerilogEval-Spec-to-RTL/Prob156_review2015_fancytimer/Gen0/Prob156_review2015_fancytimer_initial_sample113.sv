module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] state; // 0 - IDLE, 1 - SHIFT, 2 - COUNT, 3 - DONE
reg [3:0] delay; // delay value
reg [3:0] remaining; // remaining time
reg [9:0] counter; // counter for clock cycles
reg [3:0] count_out; // output count
reg counting_out; // output counting
reg done_out; // output done
reg [3:0] shift_reg; // shift register for input pattern

always @(posedge clk) begin
    if (reset) begin
        state <= 4'd0; // reset to IDLE state
        done_out <= 1'd0;
        counting_out <= 1'd0;
        count_out <= 4'd0;
        counter <= 10'd0;
        remaining <= 4'd0;
        delay <= 4'd0;
        shift_reg <= 4'd0;
    end else begin
        case (state)
            4'd0: begin // IDLE state
                if (shift_reg == 4'd13) begin // 1101 in binary is 13
                    state <= 4'd1; // go to SHIFT state
                    shift_reg <= 4'd0;
                end else begin
                    shift_reg <= {data, shift_reg[3:1]}; // shift in data
                end
            end
            4'd1: begin // SHIFT state
                shift_reg <= {data, shift_reg[3:1]}; // shift in data
                if (shift_reg[0] == 1'd1) begin // most significant bit is 1
                    delay <= shift_reg[3:0]; // get delay value
                    state <= 4'd2; // go to COUNT state
                    remaining <= delay + 1'd1; // set remaining time
                    counter <= 10'd0; // reset counter
                    counting_out <= 1'd1; // assert counting
                end
            end
            4'd2: begin // COUNT state
                counter <= counter + 1'd1; // increment counter
                if (counter == 10'd1000) begin // 1000 clock cycles
                    counter <= 10'd0; // reset counter
                    remaining <= remaining - 1'd1; // decrement remaining time
                    if (remaining == 4'd0) begin
                        state <= 4'd3; // go to DONE state
                        counting_out <= 1'd0; // deassert counting
                    end
                end
                count_out <= remaining - 1'd1; // output remaining time
            end
            4'd3: begin // DONE state
                done_out <= 1'd1; // assert done
                if (ack) begin
                    state <= 4'd0; // go to IDLE state
                    done_out <= 1'd0; // deassert done
                end
            end
        endcase
    end
end

assign count = count_out;
assign counting = counting_out;
assign done = done_out;

endmodule