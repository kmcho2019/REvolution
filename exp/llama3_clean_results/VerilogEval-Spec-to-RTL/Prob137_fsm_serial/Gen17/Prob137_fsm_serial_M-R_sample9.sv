module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [7:0] data; // 8-bit register to collect incoming data bits
reg [2:0] state; // 3-bit state register (IDLE, RECEIVE, WAIT_STOP)
reg [3:0] bit_count; // Counter to keep track of number of bits received

// One-hot encoding for state machine
reg idle, receive, wait_stop;

always_ff @(posedge clk) begin
    if (reset) begin
        idle <= 1'b1;
        receive <= 1'b0;
        wait_stop <= 1'b0;
        bit_count <= 4'b0;
        data <= 8'b0;
        done <= 1'b0;
    end else begin
        case ({idle, receive, wait_stop})
            3'b100: begin // IDLE state
                if (~in) begin
                    idle <= 1'b0;
                    receive <= 1'b1;
                    wait_stop <= 1'b0;
                    bit_count <= 4'b1;
                    data <= {7'b0, in};
                end
            end
            3'b010: begin // RECEIVE state
                data <= {data[6:0], in};
                bit_count <= bit_count + 1;
                if (bit_count == 9) begin
                    if (in) begin
                        done <= 1'b1;
                        idle <= 1'b1;
                        receive <= 1'b0;
                        wait_stop <= 1'b0;
                    end else begin
                        idle <= 1'b0;
                        receive <= 1'b0;
                        wait_stop <= 1'b1;
                    end
                    bit_count <= 4'b0;
                end
            end
            3'b001: begin // WAIT_STOP state
                if (in) begin
                    idle <= 1'b1;
                    receive <= 1'b0;
                    wait_stop <= 1'b0;
                end
            end
        endcase
        if (done) begin
            done <= 1'b0;
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