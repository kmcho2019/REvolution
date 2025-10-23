module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

// Define states for the finite state machine
localparam IDLE = 2'b00;
localparam START = 2'b01;
localparam DATA = 2'b10;
localparam STOP = 2'b11;

reg [1:0] state;
reg [7:0] data;
reg [3:0] bit_counter;

// Sequential logic for state and data
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        data <= 8'b0;
        bit_counter <= 4'b0000;
        done <= 0;
    end else begin
        case(state)
            IDLE: begin
                if (!in) begin
                    state <= START;
                    bit_counter <= 4'b0001;
                end
            end
            START: begin
                state <= DATA;
            end
            DATA: begin
                data[bit_counter - 1] <= in; // Assign bits from LSB to MSB
                bit_counter <= bit_counter + 1;
                if (bit_counter == 4'd9) begin
                    state <= STOP;
                end
            end
            STOP: begin
                if (in) begin // Stop bit received
                    done <= 1;
                    out_byte <= data;
                    state <= IDLE;
                end
            end
        endcase
    end
end

// Combinational logic for done signal
always @(posedge clk) begin
    if (state != STOP || !in) begin
        done <= 0;
    end
end

endmodule