module TopModule (
    input  clk,
    input  reset,
    input  in,
    output done
);

reg [7:0] data; // Register to hold the received byte
reg [2:0] state; // FSM state register: 3 states (2 bits) + idle (0)
reg [3:0] bit_count; // Counter for data bits
reg done_reg; // Internal done signal

// Define states
parameter IDLE = 3'b001;
parameter RECEIVE = 3'b010;
parameter STOP = 3'b100;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        data <= 8'd0;
        bit_count <= 4'd0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (~in) begin // Start bit detected
                    state <= RECEIVE;
                    bit_count <= 4'd1;
                    data[0] <= ~in; // Start bit is always 0
                end
            end
            RECEIVE: begin
                data[bit_count] <= in; // Store the current bit
                if (bit_count == 4'd7) begin // All 8 bits received
                    state <= STOP;
                end else begin
                    bit_count <= bit_count + 1;
                end
            end
            STOP: begin
                if (in) begin // Stop bit detected
                    done_reg <= 1'b1; // Set done for one cycle
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

always @(posedge clk) begin
    done <= done_reg;
    if (~done_reg) begin // Clear done_reg after one cycle
        done_reg <= 1'b0;
    end
end

endmodule