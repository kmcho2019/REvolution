module TopModule(
    input           clk,
    input           reset,
    input           in,
    output          done
);

reg [2:0] state;
reg [7:0] data;
reg [2:0] bit_counter;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE state
        done <= 0;
        data <= 0;
        bit_counter <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // Start bit detected
                    state <= 1; // Go to START state
                    bit_counter <= 0; // Reset bit counter
                end
            end
            1: begin // START
                state <= 2; // Go to DATA state
            end
            2: begin // DATA
                data[bit_counter] <= in; // Store the received bit
                bit_counter <= bit_counter + 1;
                if (bit_counter == 7) begin // All data bits received
                    state <= 3; // Go to STOP state
                end
            end
            3: begin // STOP
                if (in) begin // Stop bit received correctly
                    done <= 1; // Assert done signal
                    state <= 0; // Return to IDLE state
                end else begin // Stop bit not received, error
                    state <= 4; // Go to ERROR state
                end
            end
            4: begin // ERROR
                if (in) begin // Wait for a stop bit (1)
                    state <= 0; // Return to IDLE state
                end
            end
            default: state <= 0;
        endcase
        if (state != 3) begin // Deassert done signal unless in STOP state
            done <= 0;
        end
    end
end

endmodule