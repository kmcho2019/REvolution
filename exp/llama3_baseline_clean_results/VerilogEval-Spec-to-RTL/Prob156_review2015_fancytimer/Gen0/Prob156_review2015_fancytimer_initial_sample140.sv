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
reg [3:0] delay_count;
reg [9:0] cycle_count;
reg [3:0] pattern_register;
reg pattern_detected;
reg [1:0] state;

localparam SEARCH = 2'b00;
localparam SHIFT_DELAY = 2'b01;
localparam COUNT = 2'b10;

always @(posedge clk) begin
    if (reset) begin
        state <= SEARCH;
        pattern_detected <= 1'b0;
        delay_count <= 4'b0;
        cycle_count <= 10'b0;
        count <= 4'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end
    else begin
        case (state)
            SEARCH: begin
                if (pattern_detected) begin
                    state <= SHIFT_DELAY;
                    pattern_detected <= 1'b0;
                    delay_count <= 4'b0;
                end
                else begin
                    pattern_register <= {pattern_register[2:0], data};
                    if (pattern_register == 4'b1101) begin
                        pattern_detected <= 1'b1;
                    end
                end
            end
            SHIFT_DELAY: begin
                if (delay_count == 4'b1000) begin
                    state <= COUNT;
                end
                else begin
                    delay_count <= delay_count + 1'b1;
                    delay <= {delay[2:0], data};
                end
            end
            COUNT: begin
                if (cycle_count == 10'b1001110000 + (delay * 10'b1000)) begin
                    state <= SEARCH;
                    done <= 1'b1;
                end
                else begin
                    cycle_count <= cycle_count + 1'b1;
                    if (cycle_count % 10'b1000 == 10'b0) begin
                        count <= count - 1'b1;
                    end
                    counting <= 1'b1;
                end
                if (ack) begin
                    done <= 1'b0;
                    state <= SEARCH;
                    count <= 4'b0;
                    counting <= 1'b0;
                end
            end
        endcase
    end
end
endmodule