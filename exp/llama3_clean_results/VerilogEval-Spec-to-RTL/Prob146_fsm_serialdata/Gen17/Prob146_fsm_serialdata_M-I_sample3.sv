module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// Define states for the finite state machine
localparam IDLE = 2'b00;
localparam START = 2'b01;
localparam DATA = 2'b10;
localparam STOP = 2'b11;

reg [1:0] state;
reg [7:0] data;
reg [2:0] bit_counter;

// Sequential logic for state and data
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        data <= 8'b0;
        bit_counter <= 3'b000;
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
                data <= {7'b0, in}; // Store the first data bit in the LSB
            end
            DATA: begin
                if (bit_counter < 3'd8) begin
                    data <= {data[6:0], in}; // Shift data bits to the left and store the new bit in the LSB
                    bit_counter <= bit_counter + 1;
                end else begin
                    state <= STOP;
                end
            end
            STOP: begin
                if (in) begin // Stop bit received correctly
                    state <= IDLE;
                end else begin // Stop bit not received correctly, wait for a stop bit
                    state <= IDLE;
                end
            end
        endcase
    end
end

// Combinational logic for done signal and out_byte
assign done = (state == STOP && in);
assign out_byte = (state == STOP && in) ? data : 8'b0;

endmodule