module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// Byte detection module
module byte_detection(
    input clk,
    input reset,
    input in,
    output reg start_bit,
    output reg stop_bit
);

reg [1:0] state; // 2-bit state register (IDLE, START)
reg [3:0] bit_count; // Counter to keep track of number of bits received

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b01; // Reset to IDLE state
        bit_count <= 4'b0; // Reset counter
        start_bit <= 1'b0; // Reset start bit signal
        stop_bit <= 1'b0; // Reset stop bit signal
    end else begin
        case (state)
            2'b01: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 2'b10; // Move to START state
                    bit_count <= 4'b1; // Increment counter
                    start_bit <= 1'b1; // Set start bit signal high
                end
            end
            2'b10: begin // START state
                if (bit_count == 9) begin // 9 bits received
                    if (in) begin // Stop bit correct
                        stop_bit <= 1'b1; // Set stop bit signal high
                        state <= 2'b01; // Reset to IDLE state
                    end else begin // Stop bit incorrect
                        state <= 2'b10; // Stay in START state
                    end
                    bit_count <= 4'b0; // Reset counter
                end else begin
                    bit_count <= bit_count + 1; // Increment counter
                end
            end
        endcase
        if (start_bit) begin
            start_bit <= 1'b0; // Reset start bit signal
        end
        if (stop_bit) begin
            stop_bit <= 1'b0; // Reset stop bit signal
        end
    end
end

endmodule

// Finite state machine module
module fsm(
    input clk,
    input reset,
    input start_bit,
    input stop_bit,
    output reg done
);

reg [2:0] state; // 3-bit state register (IDLE, RECEIVE, DONE)
reg [7:0] data; // 8-bit register to collect incoming data bits
reg [3:0] bit_count; // Counter to keep track of number of bits received

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b001; // Reset to IDLE state
        bit_count <= 4'b0; // Reset counter
        data <= 8'b0; // Reset data register
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            3'b001: begin // IDLE state
                if (start_bit) begin // Start bit detected
                    state <= 3'b010; // Move to RECEIVE state
                    bit_count <= 4'b1; // Increment counter
                    data <= {7'b0, 1'b0}; // Load start bit into data register
                end
            end
            3'b010: begin // RECEIVE state
                data <= {data[6:0], 1'b0}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
                if (bit_count == 9) begin // 9 bits received
                    if (stop_bit) begin // Stop bit correct
                        done <= 1'b1; // Set done signal high
                        state <= 3'b001; // Reset to IDLE state
                    end else begin // Stop bit incorrect
                        state <= 3'b010; // Stay in RECEIVE state
                    end
                    bit_count <= 4'b0; // Reset counter
                end
            end
        endcase
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule

byte_detection byte_detection_instance(
    .clk(clk),
    .reset(reset),
    .in(in),
    .start_bit(start_bit),
    .stop_bit(stop_bit)
);

fsm fsm_instance(
    .clk(clk),
    .reset(reset),
    .start_bit(start_bit),
    .stop_bit(stop_bit),
    .done(done)
);

endmodule

module testbench;
    reg clk;
    reg reset;
    reg in;
    wire done;

    TopModule top_module(
       .clk(clk),
       .reset(reset),
       .in(in),
       .done(done)
    );

    initial begin
        $display("FSM simulation started");
        clk = 0;
        reset = 1;
        in = 1;
        #10;
        reset = 0;
        in = 0; // Start bit
        #10;
        in = 1; // Data bit 1
        #10;
        in = 0; // Data bit 2
        #10;
        in = 1; // Data bit 3
        #10;
        in = 0; // Data bit 4
        #10;
        in = 1; // Data bit 5
        #10;
        in = 0; // Data bit 6
        #10;
        in = 1; // Data bit 7
        #10;
        in = 0; // Data bit 8
        #10;
        in = 1; // Stop bit
        #10;
        $display("FSM simulation completed");
        $finish;
    end

    always #5 clk = ~clk;

endmodule