module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

parameter SEQUENCE_BITS = 4;
parameter DELAY_BITS = 4;

reg [1:0] state;
reg [SEQUENCE_BITS-1:0] seq_reg;
reg [DELAY_BITS-1:0] delay_reg;
reg [19:0] counter;
reg [DELAY_BITS-1:0] remaining_delay;

// State machine
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (seq_reg == 4'b1101) begin
                    state <= 1;
                end
            end
            1: begin // SHIFT
                if (delay_reg[0]) begin // Assuming MSB is first bit received
                    state <= 2;
                end
            end
            2: begin // COUNT
                if (counter == 0) begin
                    state <= 3;
                end
            end
            3: begin // DONE
                if (ack == 1'b1) begin
                    state <= 0;
                end
            end
        endcase
    end
end

// Sequence register
always @(posedge clk or posedge reset) begin
    if (reset) begin
        seq_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                seq_reg <= {seq_reg[SEQUENCE_BITS-2:0], data};
            end
            default: begin
                seq_reg <= seq_reg;
            end
        endcase
    end
end

// Delay register
always @(posedge clk or posedge reset) begin
    if (reset) begin
        delay_reg <= 0;
    end else begin
        case (state)
            1: begin // SHIFT
                delay_reg <= {data, delay_reg[DELAY_BITS-1:1]};
            end
            default: begin
                delay_reg <= delay_reg;
            end
        endcase
    end
end

// Counter
always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0;
    end else begin
        case (state)
            2: begin // COUNT
                if (counter > 0) begin
                    counter <= counter - 1;
                end
            end
            1: begin // SHIFT
                if (delay_reg[0]) begin // Assuming MSB is first bit received
                    counter <= (delay_reg + 1) * 1000 - 1;
                end
            end
            default: begin
                counter <= counter;
            end
        endcase
    end
end

// Remaining delay
always @(posedge clk or posedge reset) begin
    if (reset) begin
        remaining_delay <= 0;
    end else begin
        case (state)
            2: begin // COUNT
                if (counter > 0 && counter % 1000 == 0) begin
                    remaining_delay <= remaining_delay - 1;
                end
            end
            1: begin // SHIFT
                if (delay_reg[0]) begin // Assuming MSB is first bit received
                    remaining_delay <= delay_reg;
                end
            end
            default: begin
                remaining_delay <= remaining_delay;
            end
        endcase
    end
end

// Output assignments
assign count = remaining_delay;
assign counting = (state == 2);
assign done = (state == 3);

endmodule