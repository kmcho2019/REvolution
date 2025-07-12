module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] state; // state register
reg [3:0] delay; // delay register
reg [3:0] counter; // counter register
reg [3:0] pattern; // pattern register
reg shift_enable; // shift enable signal
reg count_enable; // count enable signal

// state definition
localparam IDLE = 4'd0;
localparam SHIFT_DELAY = 4'd1;
localparam COUNT = 4'd2;
localparam DONE = 4'd3;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'd0;
        delay <= 4'd0;
        counter <= 4'd0;
        counting <= 1'd0;
        done <= 1'd0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    pattern <= {pattern[2:0], 1'b1};
                    if (pattern == 4'd13) begin
                        state <= SHIFT_DELAY;
                    end
                end else begin
                    pattern <= {pattern[2:0], 1'b0};
                    if (pattern == 4'd0) begin
                        pattern <= 4'd0;
                    end
                end
            end
            SHIFT_DELAY: begin
                delay <= {delay[2:0], data};
                shift_enable <= ~shift_enable;
                if (shift_enable) begin
                    state <= COUNT;
                end
            end
            COUNT: begin
                if (counter == (delay + 1) * 1000 - 1) begin
                    state <= DONE;
                end else begin
                    counter <= counter + 1;
                end
                if (counter % 1000 == 999) begin
                    delay <= delay - 1;
                end
                counting <= 1'd1;
                count <= delay;
            end
            DONE: begin
                done <= 1'd1;
                if (ack) begin
                    state <= IDLE;
                    pattern <= 4'd0;
                    delay <= 4'd0;
                    counter <= 4'd0;
                    counting <= 1'd0;
                    done <= 1'd0;
                end
            end
        endcase
    end
end

endmodule