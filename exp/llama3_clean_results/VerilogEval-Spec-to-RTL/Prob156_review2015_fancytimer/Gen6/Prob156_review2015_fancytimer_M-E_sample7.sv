module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

parameter SEQUENCE_BITS = 4;
parameter DELAY_BITS = 4;

// Controller module
module Controller(
    input clk,
    input reset,
    input data,
    input delay,
    output reg counting,
    output reg done,
    input ack
);
reg [1:0] state;
reg [SEQUENCE_BITS-1:0] seq_reg;
reg [DELAY_BITS-1:0] delay_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        seq_reg <= 0;
        delay_reg <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                // Search for the input sequence 1101
                seq_reg <= {seq_reg[SEQUENCE_BITS-2:0], data};
                if (seq_reg == 4'b1101) begin
                    state <= 1;
                end
            end
            1: begin // SHIFT
                // Shift in the next 4 bits to determine the delay duration
                delay_reg <= {data, delay_reg[DELAY_BITS-1:1]};
                if (delay_reg[DELAY_BITS-1]) begin
                    state <= 2;
                end
            end
            2: begin // COUNT
                // Count up to the desired number of clock cycles
                counting <= 1;
                if (delay == 0) begin
                    state <= 3;
                end else begin
                    delay_reg <= delay_reg - 1;
                end
            end
            3: begin // DONE
                // Wait for the ack signal to reset the state machine
                done <= 1;
                if (ack == 1'b1) begin
                    state <= 0;
                    counting <= 0;
                    done <= 0;
                end
            end
        endcase
    end
end

assign count = delay_reg;

endmodule

// Sequential Detector module
module SequentialDetector(
    input clk,
    input reset,
    input data,
    output reg detected
);
reg [SEQUENCE_BITS-1:0] seq_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        seq_reg <= 0;
        detected <= 0;
    end else begin
        seq_reg <= {seq_reg[SEQUENCE_BITS-2:0], data};
        if (seq_reg == 4'b1101) begin
            detected <= 1;
        end else begin
            detected <= 0;
        end
    end
end

endmodule

// Delay Register module
module DelayRegister(
    input clk,
    input reset,
    input data,
    output reg [DELAY_BITS-1:0] delay
);
reg [DELAY_BITS-1:0] delay_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        delay_reg <= 0;
    end else begin
        delay_reg <= {data, delay_reg[DELAY_BITS-1:1]};
    end
end

assign delay = delay_reg;

endmodule

// Counter module
module Counter(
    input clk,
    input reset,
    input enable,
    output reg [19:0] count
);
reg [19:0] counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0;
    end else if (enable) begin
        counter <= counter + 1;
    end
end

assign count = counter;

endmodule

endmodule