module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

reg [3:0] pattern_reg;
reg [1:0] state;
reg [1:0] shift_count;

// State definitions
localparam IDLE = 2'b00;
localparam SHIFT = 2'b01;
localparam COUNT = 2'b10;
localparam DONE = 2'b11;

// Initialize outputs
assign shift_ena = (state == SHIFT) && (shift_count != 4);
assign counting = (state == COUNT);
assign done = (state == DONE);

// Shift register to detect pattern
always @(posedge clk) begin
    if (reset) begin
        pattern_reg <= 4'b0000;
    end else begin
        pattern_reg <= {pattern_reg[2:0], data};
    end
end

// State machine
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 2'b00;
    end else begin
        case (state)
            IDLE: begin
                if (pattern_reg == 4'b1101) begin
                    state <= SHIFT;
                    shift_count <= 2'b00;
                end
            end
            SHIFT: begin
                if (shift_count == 4) begin
                    state <= COUNT;
                end else begin
                    shift_count <= shift_count + 1;
                end
            end
            COUNT: begin
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