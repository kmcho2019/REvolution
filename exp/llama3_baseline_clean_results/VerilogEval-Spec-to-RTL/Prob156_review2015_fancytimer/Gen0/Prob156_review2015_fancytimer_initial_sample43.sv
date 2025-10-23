module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT, 3: DONE
reg [3:0] delay; // 4-bit delay value
reg [3:0] remaining; // remaining time
reg [9:0] counter; // 10-bit counter for clock cycles
reg [3:0] pattern; // 4-bit pattern for start sequence
reg found;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        pattern <= 0;
        found <= 0;
        delay <= 0;
        remaining <= 0;
        counter <= 0;
        count <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data == 1'b1) begin
                    pattern <= {pattern[2:0], 1'b1};
                end else begin
                    pattern <= {pattern[2:0], 1'b0};
                end
                if (pattern == 4'b1101) begin
                    state <= 1; // SHIFT
                    pattern <= 0;
                    found <= 1;
                end
            end
            1: begin // SHIFT
                delay <= {delay[2:0], data};
                if (counter == 4'd3) begin
                    state <= 2; // COUNT
                    counter <= 0;
                    remaining <= delay + 1;
                end else begin
                    counter <= counter + 1;
                end
            end
            2: begin // COUNT
                count <= remaining;
                counting <= 1'b1;
                if (counter == 10'd999) begin
                    counter <= 0;
                    remaining <= remaining - 1;
                    if (remaining == 0) begin
                        state <= 3; // DONE
                    end
                end else begin
                    counter <= counter + 1;
                end
            end
            3: begin // DONE
                done <= 1'b1;
                counting <= 0;
                if (ack) begin
                    state <= 0; // IDLE
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule