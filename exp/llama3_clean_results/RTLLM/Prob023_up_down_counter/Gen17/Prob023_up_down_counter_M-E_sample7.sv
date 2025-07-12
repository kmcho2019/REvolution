module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [1:0] state;  // State machine state (IDLE, INCREMENT, DECREMENT)

// Define the states
localparam IDLE = 2'b00;
localparam INCREMENT = 2'b01;
localparam DECREMENT = 2'b10;

always @ (posedge clk) begin
    case (state)
        IDLE: begin
            if (reset) begin
                count <= 16'd0;
                state <= IDLE;
            end else if (up_down) begin
                state <= INCREMENT;
            end else if (~up_down) begin
                state <= DECREMENT;
            end else begin
                state <= IDLE;
            end
        end
        INCREMENT: begin
            count <= count + 1;
            if (count == 16'd65535) begin
                count <= 16'd0;
            end
            state <= IDLE;
        end
        DECREMENT: begin
            if (count == 16'd0) begin
                count <= 16'd65535;
            end else begin
                count <= count - 1;
            end
            state <= IDLE;
        end
        default: begin
            state <= IDLE;
        end
    endcase
end

initial begin
    state <= IDLE;
end

endmodule