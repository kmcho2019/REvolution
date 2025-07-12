module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

// Define states for the Bit Detector
localparam IDLE_BIT = 2'b00;
localparam START_BIT = 2'b01;
localparam DATA_BIT = 2'b10;

reg [1:0] bit_state;
reg [2:0] bit_counter;
reg [7:0] data;

// Bit Detector sequential logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        bit_state <= IDLE_BIT;
        bit_counter <= 3'b000;
        done <= 0;
    end else begin
        case(bit_state)
            IDLE_BIT: begin
                if (!in) begin
                    bit_state <= START_BIT;
                    bit_counter <= 3'b001;
                end
            end
            START_BIT: begin
                bit_state <= DATA_BIT;
            end
            DATA_BIT: begin
                data <= {data[6:0], in};
                bit_counter <= bit_counter + 1;
                if (bit_counter == 3'd9) begin
                    if (in) begin
                        bit_state <= IDLE_BIT;
                        done <= 1;
                        out_byte <= data;
                    end else begin
                        // Wait for stop bit
                        bit_state <= DATA_BIT;
                    end
                end
            end
            default: begin
                bit_state <= IDLE_BIT;
            end
        endcase
        if (bit_state != DATA_BIT || bit_counter != 3'd9 || !in) begin
            done <= 0;
        end
    end
end

endmodule