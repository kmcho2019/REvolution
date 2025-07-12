module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] delay_reg;
reg [19:0] counter;
reg [3:0] sequence;
reg [2:0] state;
reg [2:0] next_state;

parameter IDLE = 3'b001;
parameter DETECT_SEQUENCE = 3'b010;
parameter COUNTING = 3'b100;
parameter DONE = 3'b111;

reg sequence_detect;
reg [3:0] delay_bit_count;

// Sequence Detector Module
always @(posedge clk or posedge reset) begin
    if (reset) begin
        sequence <= 4'd0;
        sequence_detect <= 1'b0;
    end
    else if (state == IDLE) begin
        sequence <= {sequence[2:0], data};
        if (sequence == 4'b1101) begin
            sequence_detect <= 1'b1;
        end
        else begin
            sequence_detect <= 1'b0;
        end
    end
end

// Counting Module
always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 20'd0;
        delay_reg <= 4'd0;
        delay_bit_count <= 4'd0;
    end
    else if (state == DETECT_SEQUENCE) begin
        if (delay_bit_count < 4) begin
            delay_reg <= {data, delay_reg[3:1]};
            delay_bit_count <= delay_bit_count + 1'b1;
        end
    end
    else if (state == COUNTING) begin
        if (counter > 20'd0) begin
            counter <= counter - 1;
            if (counter % 1000 == 999) begin
                count <= count - 1;
            end
        end
    end
end

// Finite State Machine
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
    end
    else begin
        case (state)
            IDLE: begin
                if (sequence_detect) begin
                    state <= DETECT_SEQUENCE;
                end
            end
            DETECT_SEQUENCE: begin
                if (delay_bit_count == 4) begin
                    counter <= (delay_reg + 1) * 1000 - 1;
                    count <= delay_reg;
                    state <= COUNTING;
                end
            end
            COUNTING: begin
                if (counter == 20'd0) begin
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