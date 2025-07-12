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
reg [3:0] sequence;
reg [2:0] state;

parameter IDLE = 3'b001;
parameter DETECT_SEQUENCE = 3'b010;
parameter COUNTING = 3'b100;
parameter DONE = 3'b111;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        count <= 4'd0;
        sequence <= 4'd0;
        counter <= 20'd0;
        delay <= 4'd0;
    end
    else begin
        case (state)
            IDLE: begin
                sequence <= {sequence[2:0], data};
                if (sequence == 4'b1101) begin
                    state <= DETECT_SEQUENCE;
                end
            end
            DETECT_SEQUENCE: begin
                sequence <= {sequence[2:0], data};
                if (sequence[3]) begin
                    delay[3] <= sequence[0];
                end
                else if (sequence[2]) begin
                    delay[2] <= sequence[0];
                end
                else if (sequence[1]) begin
                    delay[1] <= sequence[0];
                end
                else begin
                    delay[0] <= sequence[0];
                    state <= COUNTING;
                    counter <= (delay + 1) * 1000 - 1;
                    count <= delay;
                end
            end
            COUNTING: begin
                if (counter > 20'd0) begin
                    counter <= counter - 1;
                    if (counter % 1000 == 999) begin
                        count <= count - 1;
                    end
                end
                else begin
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

assign counting = (state == COUNTING);
assign done = (state == DONE);

endmodule