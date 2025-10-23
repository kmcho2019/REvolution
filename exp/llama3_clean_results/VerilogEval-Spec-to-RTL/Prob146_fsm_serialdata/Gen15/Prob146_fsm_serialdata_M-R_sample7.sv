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

reg [1:0] state;
reg [7:0] data;
reg [2:0] bit_counter;

// Sequential logic for state and data
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        data <= 8'b0;
        bit_counter <= 3'b000;
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
                bit_counter <= 3'b001;
                data[0] <= in;
            end
            DATA: begin
                if (bit_counter < 3'd8) begin
                    data[bit_counter] <= in;
                    bit_counter <= bit_counter + 1;
                end else if (in) begin // Stop bit received
                    state <= IDLE;
                    done <= 1;
                    out_byte <= data;
                end
            end
        endcase
    end
end

// Combinational logic for done signal
assign done = (state == DATA && bit_counter == 3'd8 && in);

endmodule