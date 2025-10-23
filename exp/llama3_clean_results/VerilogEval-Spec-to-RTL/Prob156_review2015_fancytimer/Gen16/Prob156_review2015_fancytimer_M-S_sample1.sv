module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [1:0] state;
reg [3:0] delay;
reg [19:0] counter;

// State machine
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        delay <= 0;
        counter <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if ({data, delay[2:0]} == 4'b1101) begin
                    state <= 1;
                    delay <= 0;
                end else begin
                    delay <= {data, delay[2:0]};
                end
            end
            1: begin // SHIFT_COUNT
                if (counter > 0) begin
                    counter <= counter - 1;
                    counting <= 1;
                    if (counter % 1000 == 0) begin
                        delay <= delay - 1;
                    end
                end else begin
                    state <= 2;
                    counting <= 0;
                end
            end
            2: begin // DONE
                if (ack == 1'b1) begin
                    state <= 0;
                    done <= 0;
                end else begin
                    done <= 1;
                end
            end
        endcase
    end
end

// Assign outputs
assign count = (state == 1)? delay : 4'bxxxx;

// Initialize counter
always @(posedge clk) begin
    if (state == 0 && {data, delay[2:0]} == 4'b1101) begin
        counter <= (delay + 1) * 1000 - 1;
    end else if (state == 1 && counter == 0) begin
        counter <= (delay + 1) * 1000 - 1;
    end
end

endmodule