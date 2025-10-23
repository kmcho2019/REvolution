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
localparam IDLE = 2'b00;
localparam SHIFT = 2'b01;
localparam COUNT = 2'b10;
localparam DONE_ACK = 2'b11;

reg [1:0] state;
reg [3:0] pattern;
reg [1:0] shift_count;

// Pattern detection and state machine
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'b0000;
        shift_count <= 2'b00;
    end else begin
        case (state)
            IDLE: begin
                pattern[3:1] <= pattern[2:0];
                pattern[0] <= data;
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                end
            end
            SHIFT: begin
                if (shift_count == 2'b11) begin
                    state <= COUNT;
                end else begin
                    shift_count <= shift_count + 1'b1;
                end
            end
            COUNT: begin
                if (done_counting) begin
                    state <= DONE_ACK;
                end
            end
            DONE_ACK: begin
                if (ack) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

// Output assignments
assign shift_ena = (state == SHIFT);
assign counting = (state == COUNT);
assign done = (state == DONE_ACK);

endmodule