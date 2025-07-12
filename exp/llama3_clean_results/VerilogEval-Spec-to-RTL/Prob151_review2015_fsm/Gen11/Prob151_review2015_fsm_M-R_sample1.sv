module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

// Define the states
localparam RESET = 4'b0000;
localparam IDLE = 4'b0001;
localparam SHIFT = 4'b0010;
localparam COUNT = 4'b0011;
localparam DONE = 4'b0100;

reg [3:0] state;
reg [3:0] next_state;
reg [3:0] pattern;
reg [3:0] shift_data;
reg [1:0] shift_count;

// Pattern detector
always @(posedge clk) begin
    if (reset) begin
        pattern <= 4'b0000;
    end else if (state == IDLE) begin
        pattern[3:1] <= pattern[2:0];
        pattern[0] <= data;
    end
end

// Data shifter
always @(posedge clk) begin
    if (reset) begin
        shift_data <= 4'b0000;
        shift_count <= 2'b00;
    end else if (state == SHIFT) begin
        shift_data[3:1] <= shift_data[2:0];
        shift_data[0] <= data;
        if (shift_count == 2'b11) begin
            shift_count <= 2'b00;
        end else begin
            shift_count <= shift_count + 1'b1;
        end
    end
end

// Next state logic
always @(*) begin
    case (state)
        RESET: next_state = IDLE;
        IDLE: if (pattern == 4'b1101) next_state = SHIFT; else next_state = IDLE;
        SHIFT: if (shift_count == 2'b11) next_state = COUNT; else next_state = SHIFT;
        COUNT: if (done_counting) next_state = DONE; else next_state = COUNT;
        DONE: if (ack) next_state = IDLE; else next_state = DONE;
        default: next_state = IDLE;
    endcase
end

// State register
always @(posedge clk) begin
    if (reset) begin
        state <= RESET;
    end else begin
        state <= next_state;
    end
end

// Output logic
assign counting = (state == COUNT);
assign done = (state == DONE);
assign shift_ena = (state == SHIFT);

endmodule