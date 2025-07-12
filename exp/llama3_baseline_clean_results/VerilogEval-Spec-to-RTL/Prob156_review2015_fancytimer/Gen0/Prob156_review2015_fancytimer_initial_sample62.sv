module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] state; // 0: Idle, 1: Shift, 2: Count, 3: Done
reg [3:0] delay; // stores the delay value
reg [3:0] current_count; // stores the current count value
reg [9:0] counter; // counter for remaining clock cycles
reg [3:0] pattern; // stores the input pattern
reg counting_reg; // stores whether we're currently counting

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // reset to Idle state
        pattern <= 0;
        delay <= 0;
        current_count <= 0;
        counter <= 0;
        counting_reg <= 0;
    end else begin
        case (state)
            0: begin // Idle state
                if (data == 1'b1) begin
                    pattern <= {pattern[2:0], 1'b1};
                end else begin
                    pattern <= {pattern[2:0], 1'b0};
                end
                if (pattern == 4'b1101) begin
                    state <= 1; // transition to Shift state
                    pattern <= 0;
                end
            end
            1: begin // Shift state
                delay <= {delay[2:0], data};
                if (delay[3] == 1'b1) begin
                    state <= 2; // transition to Count state
                    current_count <= delay;
                    counter <= (delay + 1) * 1000;
                    counting_reg <= 1'b1;
                end
            end
            2: begin // Count state
                if (counter > 1000) begin
                    counter <= counter - 1;
                end else if (counter > 0) begin
                    counter <= 999;
                    current_count <= current_count - 1;
                end else begin
                    state <= 3; // transition to Done state
                    counting_reg <= 1'b0;
                end
            end
            3: begin // Done state
                if (ack == 1'b1) begin
                    state <= 0; // transition to Idle state
                end
            end
        endcase
    end
end

assign count = (state == 2) ? current_count : 4'bxxxx;
assign counting = counting_reg;
assign done = (state == 3) ? 1'b1 : 1'b0;

endmodule