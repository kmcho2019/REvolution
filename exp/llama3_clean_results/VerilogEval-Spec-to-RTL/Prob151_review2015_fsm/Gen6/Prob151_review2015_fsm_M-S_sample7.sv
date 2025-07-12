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
reg [2:0] shift_counter;

localparam IDLE = 2'b00;
localparam SHIFT = 2'b01;
localparam COUNTING = 2'b10;
localparam DONE_WAIT = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'b0000;
        shift_counter <= 3'b000;
    end else begin
        case (state)
            IDLE: begin
                pattern[3:1] <= pattern[2:0];
                pattern[0] <= data;
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                    shift_counter <= 3'b000;
                end
            end
            SHIFT: begin
                if (shift_counter < 3'b100) begin
                    shift_counter <= shift_counter + 1'b1;
                end else begin
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

assign shift_ena = (state == SHIFT) & (shift_counter < 3'b100);
assign counting = (state == COUNTING);
assign done = (state == DONE_WAIT);

endmodule