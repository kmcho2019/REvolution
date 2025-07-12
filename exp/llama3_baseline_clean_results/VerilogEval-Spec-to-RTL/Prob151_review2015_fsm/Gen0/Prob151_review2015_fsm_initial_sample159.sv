module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

reg [1:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT, 3: DONE
reg [3:0] counter;
reg [3:0] pattern;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        counter <= 0;
        pattern <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (pattern == 4'b1101) begin
                    state <= 1;
                    counter <= 0;
                end else begin
                    pattern <= {pattern[2:0], data};
                end
            end
            1: begin // SHIFT
                shift_ena <= 1'b1;
                if (counter == 4) begin
                    state <= 2;
                end else begin
                    counter <= counter + 1;
                end
            end
            2: begin // COUNT
                counting <= 1'b1;
                if (done_counting) begin
                    state <= 3;
                end
            end
            3: begin // DONE
                done <= 1'b1;
                if (ack) begin
                    state <= 0;
                end
            end
            default: state <= 0;
        endcase
    end
end

always @(posedge clk) begin
    if (state != 1) begin
        shift_ena <= 1'b0;
    end
    if (state != 2) begin
        counting <= 1'b0;
    end
    if (state != 3) begin
        done <= 1'b0;
    end
end

endmodule