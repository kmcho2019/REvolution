module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [1:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT, 3: DONE
reg [3:0] delay;
reg [9:0] counter;
reg [3:0] pattern;
reg [2:0] shift_count;

always @ (posedge clk) begin
    if (reset) begin
        state <= 0;
        delay <= 0;
        counter <= 0;
        pattern <= 0;
        shift_count <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    state <= 1; // SHIFT
                    pattern <= 0;
                    shift_count <= 0;
                end
            end
            1: begin // SHIFT
                delay[3 - shift_count] <= data;
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin
                    state <= 2; // COUNT
                    counter <= (delay + 1) * 1000 - 1;
                end
            end
            2: begin // COUNT
                counter <= counter - 1;
                if (counter == 0) begin
                    if (delay == 0) begin
                        state <= 3; // DONE
                    end else begin
                        delay <= delay - 1;
                        counter <= 999; // Because we already decremented counter by 1 in this cycle
                    end
                end
            end
            3: begin // DONE
                if (ack) begin
                    state <= 0; // IDLE
                end
            end
        endcase
    end
end

assign count = (state == 2) ? delay : (state == 0) ? 4'd0 : (state == 3) ? 4'd0 : 4'd0;
assign counting = (state == 2);
assign done = (state == 3);

endmodule