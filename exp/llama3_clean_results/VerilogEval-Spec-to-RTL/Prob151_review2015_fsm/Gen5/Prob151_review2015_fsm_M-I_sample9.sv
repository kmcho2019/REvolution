module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

reg [1:0] state;
reg [3:0] pattern;
reg [3:0] delay;
reg [2:0] shift_counter; // Simplified counter for shifts

localparam IDLE = 2'b00;
localparam SHIFT = 2'b01;
localparam COUNTING = 2'b10;
localparam DONE_WAIT = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'b0000;
        delay <= 4'b0000;
        shift_counter <= 3'b000;
    end else begin
        case (state)
            IDLE: begin
                pattern[3:1] <= pattern[2:0];
                pattern[0] <= data;
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                    shift_counter <= 3'b000; // Reset shift counter
                end
            end
            SHIFT: begin
                delay[3:1] <= delay[2:0];
                delay[0] <= data;
                shift_counter <= shift_counter + 1'b1;
                if (shift_counter == 3'b100) begin // After 4 shifts
                    state <= COUNTING;
                end
            end
            COUNTING: begin
                if (done_counting) begin
                    state <= DONE_WAIT;
                end
            end
            DONE_WAIT: begin
                if (ack) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

assign shift_ena = (state == SHIFT);
assign counting = (state == COUNTING);
assign done = (state == DONE_WAIT);

endmodule