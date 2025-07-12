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

reg [3:0] pattern;
reg [3:0] counter;
reg [2:0] state;

// Define states
localparam IDLE = 3'b000;
localparam SHIFT = 3'b001;
localparam WAIT = 3'b010;
localparam DONE = 3'b011;

// Initialize outputs
assign shift_ena = (state == SHIFT);
assign counting = (state == WAIT);
assign done = (state == DONE);

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'b0000;
        counter <= 4'b0000;
    end else begin
        case (state)
            IDLE: begin
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                    counter <= 4'b0000;
                end
            end
            SHIFT: begin
                if (counter == 4'b1000) begin
                    state <= WAIT;
                end else begin
                    counter <= counter + 1;
                end
            end
            WAIT: begin
                if (done_counting) begin
                    state <= DONE;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule