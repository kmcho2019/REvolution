module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  ack
);

reg [3:0] delay;
reg [9:0] counter;
reg [3:0] remaining;
reg [3:0] pattern_register;

enum logic [1:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE
} state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern_register <= 4'b0000;
        delay <= 0;
        counter <= 0;
        remaining <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    pattern_register <= {pattern_register[2:0], 1'b1};
                end else if (data == 1'b0) begin
                    pattern_register <= {pattern_register[2:0], 1'b0};
                end
                if (pattern_register == 4'b1101) begin
                    state <= SHIFT;
                    pattern_register <= 4'b0000;
                end
            end
            SHIFT: begin
                if (data == 1'b1) begin
                    delay <= {delay[2:0], 1'b1};
                end else begin
                    delay <= {delay[2:0], 1'b0};
                end
                if (pattern_register == 4'b1111) begin
                    state <= COUNT;
                    pattern_register <= 4'b0000;
                    remaining <= delay + 1;
                    counter <= 0;
                    counting <= 1;
                end else begin
                    pattern_register <= pattern_register + 1;
                end
            end
            COUNT: begin
                if (counter == 1000) begin
                    remaining <= remaining - 1;
                    counter <= 0;
                    if (remaining == 0) begin
                        state <= DONE;
                    end
                end else begin
                    counter <= counter + 1;
                end
                count <= remaining - 1;
            end
            DONE: begin
                done <= 1;
                if (ack) begin
                    done <= 0;
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule