module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] byte;
reg [2:0] state; // 0: idle, 1: receiving, 2: stop
reg [2:0] counter;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // idle
        counter <= 0;
        done_reg <= 0;
    end
    else begin
        case (state)
            0: begin // idle
                if (~in) begin // start bit detected
                    state <= 1; // receiving
                    counter <= 1;
                    byte <= 1'b0; // clear byte
                end
            end
            1: begin // receiving
                byte <= {byte[6:0], in}; // shift in new bit
                counter <= counter + 1;
                if (counter == 8) begin
                    state <= 2; // stop
                end
            end
            2: begin // stop
                if (in) begin // stop bit detected
                    done_reg <= 1;
                    state <= 0; // idle
                end
                else begin // stop bit not detected, wait for stop bit
                    state <= 0; // idle
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if (done_reg) begin
        out_byte <= byte;
        done <= 1;
    end
    else begin
        done <= 0;
    end
end

endmodule