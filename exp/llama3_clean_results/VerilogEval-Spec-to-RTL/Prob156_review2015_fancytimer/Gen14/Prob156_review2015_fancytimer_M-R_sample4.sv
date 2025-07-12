module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] delay;
reg [19:0] counter;
reg [3:0] delay_counter;
reg [3:0] sequence;
reg [1:0] state; // Simplified state machine with fewer states
parameter IDLE = 2'b00;
parameter DETECT = 2'b01;
parameter COUNTING = 2'b10;

// Combinational logic for output assignments
assign counting = (state == COUNTING);
assign done = (state == 2'b11); // Added a DONE state as 2'b11

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        count <= 4'd0;
        sequence <= 4'd0;
        counter <= 20'd0;
        delay <= 4'd0;
        delay_counter <= 4'd0;
    end
    else begin
        case (state)
            IDLE: begin
                sequence <= {sequence[2:0], data};
                if (sequence == 4'b1101) begin
                    state <= DETECT;
                end
            end
            DETECT: begin
                // Shift in the delay bits
                if (delay_counter < 4) begin
                    case (delay_counter)
                        0: delay[3] <= data;
                        1: delay[2] <= data;
                        2: delay[1] <= data;
                        3: delay[0] <= data;
                    endcase
                    delay_counter <= delay_counter + 1;
                    if (delay_counter == 4) begin
                        state <= COUNTING;
                        delay_counter <= delay;
                        counter <= 20'd0;
                    end
                end
            end
            COUNTING: begin
                counter <= counter + 1;
                if (counter == 20'd999) begin
                    counter <= 20'd0;
                    delay_counter <= delay_counter - 1;
                    count <= delay_counter;
                end
                if (delay_counter == 4'd0) begin
                    state <= 2'b11; // Transition to DONE state
                end
            end
            2'b11: // DONE state
                if (ack) begin
                    state <= IDLE;
                end
        endcase
    end
end

endmodule