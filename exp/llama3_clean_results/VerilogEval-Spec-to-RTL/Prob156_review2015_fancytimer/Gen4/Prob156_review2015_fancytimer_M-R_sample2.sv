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
reg [1:0] shift_counter;

// Update sequence register
always @(posedge clk) begin
    if (reset) begin
        seq_reg <= 0;
    end else if (state == 0) begin
        seq_reg <= {seq_reg[2:0], data};
    end else if (state == 1) begin
        seq_reg <= 0;
    end
end

// Update shift counter
always @(posedge clk) begin
    if (reset) begin
        shift_counter <= 0;
    end else if (state == 1) begin
        shift_counter <= shift_counter + 1;
    end else begin
        shift_counter <= 0;
    end
end

// Shift in delay
always @(posedge clk) begin
    if (reset) begin
        delay <= 0;
    end else if (state == 1) begin
        delay <= {data, delay[3:1]};
    end
end

// Counting
always @(posedge clk) begin
    if (reset) begin
        counter <= 0;
        count <= 0;
    end else if (state == 2) begin
        counter <= counter + 1;
        if (counter % 1000 == 0 && counter != 0) begin
            count <= count - 1;
        end
    end else if (state == 3) begin
        counter <= 0;
        count <= 0;
    end else begin
        counter <= 0;
        count <= 0;
    end
end

// State machine
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                // Search for the input sequence 1101
                if (seq_reg == 4'b1101) begin
                    state <= 1;
                end
            end
            1: begin // SHIFT
                // Shift in the next 4 bits to determine the delay duration
                if (shift_counter == 4'd3) begin
                    state <= 2;
                end
            end
            2: begin // COUNT
                counting <= 1'b1;
                // Count up to the desired number of clock cycles
                if (counter < ((delay + 1) * 1000) - 1) begin
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
                end
            end
        endcase
    end
end

endmodule