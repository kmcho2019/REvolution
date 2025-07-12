module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

// Define states for the finite state machine
localparam IDLE = 2'b00;
localparam RECV = 2'b01;
localparam STOP = 2'b10;

reg [1:0] state;
reg [7:0] data;
reg [2:0] bit_counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        data <= 8'b0;
        bit_counter <= 3'b000;
        out_byte <= 8'b0;
        done <= 0;
    end else begin
        case(state)
            IDLE: begin
                if (!in) begin
                    state <= RECV;
                    bit_counter <= 3'b000;
                end
            end
            RECV: begin
                data <= {in, data[7:1]}; // Shift data bits to the right
                bit_counter <= bit_counter + 1;
                if (bit_counter == 3'd7) begin
                    state <= STOP;
                end
            end
            STOP: begin
                if (in) begin // Stop bit detected
                    out_byte <= data;
                    done <= 1;
                end
                state <= IDLE;
            end
        endcase
    end
end

// Reset done signal on the next clock cycle after it's set
always @(posedge clk) begin
    if (state != STOP || !in) begin
        done <= 0;
    end
end

endmodule