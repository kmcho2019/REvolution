module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

// Current state of the FSM
reg [2:0] state;

// Current bit counter
reg [2:0] bit_counter;

// Data register to store the received bits
reg [7:0] data;

// Sequential logic to update the registers
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        bit_counter <= 0;
        data <= 8'b0;
        done <= 0;
        out_byte <= 8'b0;
    end
    else begin
        case(state)
            0: begin // IDLE
                if (!in) begin
                    state <= 1; // Transition to START state on start bit
                end
            end
            1: begin // START
                state <= 2; // Transition to DATA state
                bit_counter <= 0;
            end
            2: begin // DATA
                data[7 - bit_counter] <= in; // Store data bits in the correct order
                bit_counter <= bit_counter + 1;
                if (bit_counter == 8) begin
                    state <= 3; // Transition to STOP state after 8 data bits
                end
            end
            3: begin // STOP
                if (in) begin // Verify stop bit
                    out_byte <= data; // Update out_byte
                    done <= 1; // Assert done signal
                    state <= 0; // Transition to IDLE state
                end
                else begin
                    done <= 0; // Deassert done signal if stop bit is incorrect
                    state <= 3; // Wait for stop bit if it's incorrect
                end
            end
            default: state <= 0;
        endcase
    end
end

endmodule