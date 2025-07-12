module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

reg [2:0] state; // Idle, Start, Data, Error
reg [3:0] counter; // Counter for data bits
reg [7:0] data; // Storage for received data

// Initialize state and counter
initial begin
    state = 0; // Idle
    counter = 0;
end

always @(posedge clk) begin
    if (reset) begin
        state = 0; // Idle
        counter = 0;
        done = 0;
    end else begin
        case (state)
            0: begin // Idle
                if (!in) begin // Start bit detected
                    state = 1; // Start
                end
            end
            1: begin // Start
                state = 2; // Data
                counter = 0;
                data = 0;
            end
            2: begin // Data
                data = {data[6:0], in}; // Shift in data bit
                counter = counter + 1;
                if (counter == 8) begin
                    state = 3; // Wait for stop bit
                end
            end
            3: begin // Wait for stop bit
                if (in) begin // Stop bit detected
                    state = 0; // Idle
                    done = 1; // Byte received, assert done
                end else begin
                    state = 0; // Idle, but not done
                    done = 0;
                end
            end
        endcase
    end
end

endmodule