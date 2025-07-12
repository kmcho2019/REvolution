module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] delay;
reg [19:0] counter;
reg [3:0] seq_reg;
reg [1:0] state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        delay <= 0;
        counter <= 0;
        seq_reg <= 0;
        count <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                // Search for the input sequence 1101
                seq_reg <= {seq_reg[2:0], data};
                if (seq_reg == 4'b1101) begin
                    state <= 1;
                    seq_reg <= 0;
                end
            end
            1: begin // SHIFT
                // Shift in the next 4 bits to determine the delay duration
                delay <= {data, delay[3:1]};
                if (counter == 4'd3) begin
                    state <= 2;
                    counter <= 0;
                end else begin
                    counter <= counter + 1;
                end
            end
            2: begin // COUNT
                counting <= 1'b1;
                // Count up to the desired number of clock cycles
                if (counter < ((delay + 1) * 1000) - 1) begin
                    counter <= counter + 1;
                    // Update the count output signal to display the remaining time
                    count <= delay - (counter / 1000);
                end else begin
                    state <= 3;
                end
            end
            3: begin // DONE
                done <= 1'b1;
                counting <= 0;
                // Wait for the ack signal to reset the state machine
                if (ack == 1'b1) begin
                    state <= 0;
                    done <= 0;
                    delay <= 0;
                    counter <= 0;
                    count <= 0;
                end
            end
        endcase
    end
end

endmodule