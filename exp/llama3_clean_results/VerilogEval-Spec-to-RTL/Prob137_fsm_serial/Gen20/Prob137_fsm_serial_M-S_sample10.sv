module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// Define states using enum
enum logic [1:0] {
    IDLE,
    RECEIVE,
    WAIT_STOP
} state, next_state;

reg [7:0] data; // 8-bit register to collect incoming data bits
reg [3:0] bit_count; // Counter to keep track of number of bits received

// Combinational logic for next state and output
always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (~in) begin // Start bit detected
                next_state = RECEIVE;
            end
        end
        RECEIVE: begin
            if (bit_count == 9) begin // 9 bits received
                if (in) begin // Stop bit correct
                    done = 1'b1;
                    next_state = IDLE;
                end else begin // Stop bit incorrect
                    next_state = IDLE;
                end
            end
        end
        default: next_state = IDLE;
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        bit_count <= 4'b0;
        data <= 8'b0;
        done <= 1'b0;
    end else begin
        state <= next_state;
        if (state == RECEIVE) begin
            data <= {data[6:0], in}; // Shift in new bit
            bit_count <= bit_count + 1; // Increment counter
        end else if (state == IDLE) begin
            bit_count <= 4'b0; // Reset counter
            data <= 8'b0; // Reset data register
        end
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