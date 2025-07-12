module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [1:0] state;
reg [3:0] delay;
reg [3:0] pattern;
reg [9:0] counter;
reg [3:0] count_out;

always @ (posedge clk) begin
    if (reset) begin
        state <= 0;
        delay <= 0;
        pattern <= 0;
        counter <= 0;
        count_out <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data == 1'b1) begin
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101) begin
                        state <= 1; // SHIFT
                    end
                end else begin
                    pattern <= 0;
                end
            end
            1: begin // SHIFT
                delay <= {delay[2:0], data}; // shift in delay value
                if (delay[3] == 1'b1) begin // check if all 4 bits have been shifted
                    state <= 2; // COUNT
                    counter <= (delay + 1) * 1000;
                    count_out <= delay;
                end
            end
            2: begin // COUNT
                counter <= counter - 1;
                if (counter == 0) begin
                    count_out <= count_out - 1;
                    counter <= 1000;
                    if (count_out == 0) begin
                        state <= 3; // DONE
                    end
                end
            end
            3: begin // DONE
                if (ack) begin // check for acknowledgement
                    state <= 0; // IDLE
                end
            end
        endcase
    end
end

assign count = (state == 2) ? count_out : 4'bxxxx;
assign counting = (state == 2);
assign done = (state == 3);

endmodule