module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [7:0] data; // 8-bit register to collect incoming data bits
reg [2:0] state; // 3-bit state register (IDLE, RECEIVE, WAIT_STOP)
reg [3:0] bit_count; // Counter to keep track of number of bits received

// Combinational logic for next state and output
always_comb begin
    case (state)
        3'b001: begin // IDLE state
            if (~in) begin // Start bit detected
                state_next = 3'b010; // Move to RECEIVE state
            end else begin
                state_next = 3'b001; // Stay in IDLE state
            end
        end
        3'b010: begin // RECEIVE state
            if (bit_count == 9) begin // 9 bits received
                if (in) begin // Stop bit correct
                    state_next = 3'b001; // Reset to IDLE state
                    done_next = 1'b1; // Set done signal high
                end else begin // Stop bit incorrect
                    state_next = 3'b001; // Reset to IDLE state
                    done_next = 1'b0; // Reset done signal
                end
            end else begin
                state_next = 3'b010; // Stay in RECEIVE state
                done_next = 1'b0; // Reset done signal
            end
        end
        3'b100: begin // WAIT_STOP state
            if (in) begin // Stop bit detected
                state_next = 3'b001; // Reset to IDLE state
            end else begin
                state_next = 3'b100; // Stay in WAIT_STOP state
            end
        end
    endcase
end

// Sequential logic for registers
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 3'b001; // Reset to IDLE state
        bit_count <= 4'b0; // Reset counter
        data <= 8'b0; // Reset data register
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            3'b001: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 3'b010; // Move to RECEIVE state
                    bit_count <= 4'b1; // Increment counter
                    data <= {7'b0, in}; // Load start bit into data register
                end
            end
            3'b010: begin // RECEIVE state
                data <= {data[6:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
            end
            3'b100: begin // WAIT_STOP state
                if (in) begin // Stop bit detected
                    state <= 3'b001; // Reset to IDLE state
                end
            end
        endcase
        done <= done_next;
        state <= state_next;
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