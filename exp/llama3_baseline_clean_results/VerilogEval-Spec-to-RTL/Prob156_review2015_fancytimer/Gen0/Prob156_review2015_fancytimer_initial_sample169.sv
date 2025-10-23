module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] state; // 0: searching, 1: shifting, 2: counting, 3: waiting
reg [3:0] delay; // store the delay value
reg [9:0] counter; // 10-bit counter for 1000 clock cycles
reg [3:0] remaining; // remaining time

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        count <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
        counter <= 10'd0;
        remaining <= 4'd0;
    end
    else begin
        case (state)
            0: begin // searching for start pattern
                if (data == 1'b1) begin
                    if (counter == 10'd3) begin
                        state <= 1;
                        counter <= 10'd0;
                    end
                    else if (counter == 10'd2) begin
                        if (data == 1'b1) begin
                            counter <= counter + 1;
                        end
                        else begin
                            counter <= 10'd0;
                        end
                    end
                    else if (counter == 10'd1) begin
                        if (data == 1'b0) begin
                            counter <= counter + 1;
                        end
                        else begin
                            counter <= 10'd0;
                        end
                    end
                    else begin
                        counter <= counter + 1;
                    end
                end
                else begin
                    counter <= 10'd0;
                end
            end
            1: begin // shifting in delay bits
                delay[3] <= data;
                state <= 2;
                counter <= 10'd0;
                remaining <= delay;
            end
            2: begin // counting
                if (counter == 10'd999) begin
                    counter <= 10'd0;
                    if (remaining == 4'd0) begin
                        state <= 3;
                    end
                    else begin
                        remaining <= remaining - 1;
                    end
                end
                else begin
                    counter <= counter + 1;
                end
                counting <= 1'b1;
                count <= remaining;
            end
            3: begin // waiting for ack
                done <= 1'b1;
                if (ack) begin
                    state <= 0;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule