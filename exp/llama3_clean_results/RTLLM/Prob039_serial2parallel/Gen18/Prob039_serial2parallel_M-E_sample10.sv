module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] state; // 4-bit state register for the FSM
localparam IDLE = 4'b0000, BIT0 = 4'b0001, BIT1 = 4'b0010, BIT2 = 4'b0011,
           BIT3 = 4'b0100, BIT4 = 4'b0101, BIT5 = 4'b0110, BIT6 = 4'b0111,
           BIT7 = 4'b1000;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the state and output when the reset signal is low
        state <= IDLE;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        case (state)
            IDLE: begin
                // Transition to BIT0 state and set the MSB of dout_parallel
                state <= BIT0;
                dout_parallel <= {din_serial, 7'b0000000};
                dout_valid <= 1'b0;
            end
            BIT0: begin
                // Transition to BIT1 state and update the next bit of dout_parallel
                state <= BIT1;
                dout_parallel <= {dout_parallel[6:0], din_serial};
                dout_valid <= 1'b0;
            end
            BIT1: begin
                state <= BIT2;
                dout_parallel <= {dout_parallel[6:0], din_serial};
                dout_valid <= 1'b0;
            end
            BIT2: begin
                state <= BIT3;
                dout_parallel <= {dout_parallel[6:0], din_serial};
                dout_valid <= 1'b0;
            end
            BIT3: begin
                state <= BIT4;
                dout_parallel <= {dout_parallel[6:0], din_serial};
                dout_valid <= 1'b0;
            end
            BIT4: begin
                state <= BIT5;
                dout_parallel <= {dout_parallel[6:0], din_serial};
                dout_valid <= 1'b0;
            end
            BIT5: begin
                state <= BIT6;
                dout_parallel <= {dout_parallel[6:0], din_serial};
                dout_valid <= 1'b0;
            end
            BIT6: begin
                state <= BIT7;
                dout_parallel <= {dout_parallel[6:0], din_serial};
                dout_valid <= 1'b0;
            end
            BIT7: begin
                // Set the output valid signal to 1 and reset the state
                state <= IDLE;
                dout_parallel <= {dout_parallel[6:0], din_serial};
                dout_valid <= 1'b1;
            end
            default: begin
                state <= IDLE;
                dout_parallel <= 8'b00000000;
                dout_valid <= 1'b0;
            end
        endcase
    end else begin
        // If the input is not valid, stay in the current state
        state <= state;
        dout_valid <= 1'b0;
    end
end

endmodule