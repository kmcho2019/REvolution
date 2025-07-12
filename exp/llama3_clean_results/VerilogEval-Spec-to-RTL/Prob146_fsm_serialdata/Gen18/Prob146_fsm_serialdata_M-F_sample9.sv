module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

// Define states for the finite state machine
localparam IDLE = 3'b000;
localparam START = 3'b001;
localparam DATA = 3'b010;
localparam STOP = 3'b011;

reg [2:0] state;
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
                end
            end
            START: begin
                state <= DATA;
                bit_counter <= 4'b0001;
                data[0] <= in; // Assign the start bit to the LSB
            end
            DATA: begin
                data[bit_counter] <= in; // Assign bits from LSB to MSB
                bit_counter <= bit_counter + 1;
                if (bit_counter == 4'd8) begin
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
    if (state!= STOP) begin
        done <= 0;
    end
end

endmodule