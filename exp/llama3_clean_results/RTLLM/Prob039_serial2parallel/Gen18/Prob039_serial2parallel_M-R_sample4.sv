module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

// Define the states
reg [1:0] state;
localparam IDLE = 2'b00;
localparam CONVERTING = 2'b01;

// 4-bit counter to keep track of the number of serial input data bits received
reg [3:0] cnt;

// Initialize the output valid signal to 0
initial begin
    dout_valid = 1'b0;
    state = IDLE;
    cnt = 4'b0000;
    dout_parallel = 8'b00000000;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the state, counter, output, and validity signal when reset is low
        state <= IDLE;
        cnt <= 4'b0000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (din_valid) begin
                    // If the input is valid, transition to the CONVERTING state
                    state <= CONVERTING;
                    cnt <= 4'b0001;
                    dout_parallel <= {7'b0000000, din_serial};
                    dout_valid <= 1'b0;
                end
            end
            CONVERTING: begin
                if (cnt < 4'b1000) begin
                    // If the counter is less than 8, shift in the new data and increment the counter
                    cnt <= cnt + 1'b1;
                    dout_parallel <= {dout_parallel[6:0], din_serial};
                    dout_valid <= 1'b0;
                end else begin
                    // If the counter is 8, reset the counter and set the output valid signal to 1
                    state <= IDLE;
                    cnt <= 4'b0000;
                    dout_valid <= 1'b1;
                end
            end
        endcase
    end
end

endmodule