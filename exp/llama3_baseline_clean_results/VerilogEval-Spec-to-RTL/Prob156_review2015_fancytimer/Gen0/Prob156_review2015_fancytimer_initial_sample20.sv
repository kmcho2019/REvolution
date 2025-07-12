module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] state; // 0: IDLE, 1: SHIFT, 2: COUNTING, 3: DONE
reg [3:0] delay;
reg [9:0] counter; // 10-bit counter to count 1000 clock cycles
reg [3:0] current_count;
reg [3:0] sequence;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        sequence <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (sequence == 4'b1101) begin
                    state <= 1;
                    sequence <= 0;
                end else if (data) begin
                    sequence <= {sequence[2:0], 1'b1};
                end else begin
                    sequence <= {sequence[2:0], 1'b0};
                end
            end
            1: begin // SHIFT
                delay <= {delay[2:0], data};
                state <= state + 1;
                if (data) begin
                    sequence <= {sequence[2:0], 1'b1};
                end else begin
                    sequence <= {sequence[2:0], 1'b0};
                end
                if (sequence == 4'b1000) begin
                    state <= 2;
                    counter <= 0;
                    current_count <= delay + 1;
                end
            end
            2: begin // COUNTING
                if (counter == 1000) begin
                    counter <= 0;
                    current_count <= current_count - 1;
                    if (current_count == 0) begin
                        state <= 3;
                    end
                end else begin
                    counter <= counter + 1;
                end
            end
            3: begin // DONE
                if (ack) begin
                    state <= 0;
                end
            end
        endcase
    end
end

assign counting = (state == 2);
assign done = (state == 3);
assign count = (state == 2) ? current_count : 4'bxxxx;

endmodule