module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [3:0] shift_reg; // 4-bit serial shift register
reg [1:0] state; // 2-bit state register
reg [3:0] shift_count; // 4-bit counter to count the number of clock cycles after pattern detection

// Define the states
localparam IDLE = 2'b00;
localparam SHIFT = 2'b01;
localparam COUNT = 2'b10;
localparam DONE = 2'b11;

// Initialize the outputs
initial begin
    shift_ena = 0;
    counting = 0;
    done = 0;
end

// Initialize the state and shift register
initial begin
    state = IDLE;
    shift_reg = 4'b0000;
    shift_count = 4'b0000;
end

always @(posedge clk) begin
    if (reset) begin
        // Reset the state machine
        state <= IDLE;
        shift_reg <= 4'b0000;
        shift_count <= 4'b0000;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            IDLE: begin
                // Shift in the incoming data
                shift_reg <= {shift_reg[2:0], data};
                // Check if the pattern 1101 is detected
                if (shift_reg == 4'b1101) begin
                    state <= SHIFT;
                    shift_count <= 4'b0001;
                end
            end
            SHIFT: begin
                // Assert shift_ena for 4 clock cycles
                shift_ena <= 1;
                shift_count <= shift_count + 1;
                if (shift_count == 4'b1000) begin
                    state <= COUNT;
                    shift_ena <= 0;
                    counting <= 1;
                end
            end
            COUNT: begin
                // Wait for the counters to finish counting
                if (done_counting) begin
                    state <= DONE;
                    counting <= 0;
                    done <= 1;
                end
            end
            DONE: begin
                // Notify the user and wait for acknowledgement
                if (ack) begin
                    state <= IDLE;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule