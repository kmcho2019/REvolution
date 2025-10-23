module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] state, nextState;
reg [3:0] delay;
reg [3:0] remaining;
reg [9:0] counter;
reg [3:0] shiftReg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // IDLE
        count <= 4'b0000;
        delay <= 4'b0000;
        remaining <= 4'b0000;
        counter <= 10'b0000000000;
        shiftReg <= 4'b0000;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            0: begin // IDLE
                if (shiftReg == 4'b1101) begin
                    state <= 1; // READ_DELAY
                    shiftReg <= 4'b0000;
                end else if (data) begin
                    shiftReg <= {shiftReg[2:0], 1'b1};
                end else begin
                    shiftReg <= {shiftReg[2:0], 1'b0};
                end
            end
            1: begin // READ_DELAY
                if (shiftReg == 4'b0000) begin
                    delay <= {data, shiftReg[3:1]};
                    state <= 2; // COUNTING
                    remaining <= delay + 1;
                    counter <= 10'b0000000000;
                end else begin
                    shiftReg <= {shiftReg[2:0], data};
                end
            end
            2: begin // COUNTING
                counting <= 1'b1;
                if (counter == 10'b1111101000) begin
                    counter <= 10'b0000000000;
                    if (remaining == 1) begin
                        state <= 3; // DONE
                        done <= 1'b1;
                    end else begin
                        remaining <= remaining - 1;
                    end
                end else begin
                    counter <= counter + 1;
                end
                count <= remaining;
            end
            3: begin // DONE
                if (ack) begin
                    state <= 0; // IDLE
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule