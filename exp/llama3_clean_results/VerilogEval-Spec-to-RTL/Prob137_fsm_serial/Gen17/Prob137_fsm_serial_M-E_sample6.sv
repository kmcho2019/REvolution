module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [7:0] data_buffer; // Data buffer to store incoming bits
reg [1:0] state; // Finite state machine (FSM) with 3 states: IDLE, RECEIVE, VERIFY
reg [2:0] bit_counter; // Counter to keep track of received bits

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to IDLE state
        bit_counter <= 3'b0; // Reset counter
        data_buffer <= 8'b0; // Reset data buffer
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 2'b01; // Move to RECEIVE state
                    bit_counter <= 3'b1; // Increment counter
                    data_buffer <= {7'b0, in}; // Load start bit into data buffer
                end
            end
            2'b01: begin // RECEIVE state
                data_buffer <= {data_buffer[6:0], in}; // Shift in new bit
                bit_counter <= bit_counter + 1; // Increment counter
                if (bit_counter == 8) begin // 8 bits received
                    state <= 2'b10; // Move to VERIFY state
                end
            end
            2'b10: begin // VERIFY state
                if (in) begin // Stop bit correct
                    done <= 1'b1; // Set done signal high
                    state <= 2'b00; // Reset to IDLE state
                end else begin // Stop bit incorrect
                    state <= 2'b00; // Reset to IDLE state
                end
                bit_counter <= 3'b0; // Reset counter
            end
        endcase
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

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