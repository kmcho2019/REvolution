module TopModule(
    input         clk,
    input         reset,
    input         in,
    output        done
);

reg [2:0] state;
reg [7:0] data;
reg [2:0] counter;

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Idle state
        data <= 8'b0;
        counter <= 3'b000;
        done <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // Idle state
                if (~in) begin // Start bit detected
                    state <= 3'b001; // Transition to Start state
                    data <= 8'b0;
                    counter <= 3'b000;
                end
            end
            3'b001: begin // Start state
                state <= 3'b010; // Transition to Data state
                data[0] <= in;
                counter <= 3'b001;
            end
            3'b010: begin // Data state
                data[counter] <= in;
                counter <= counter + 1;
                if (counter == 3'b100) begin
                    state <= 3'b011; // Transition to Stop state
                end
            end
            3'b011: begin // Stop state
                if (in) begin // Stop bit correct
                    done <= 1'b1;
                    state <= 3'b000; // Transition to Idle state
                end
                if (~in) begin // Stop bit incorrect, wait for stop bit
                    state <= 3'b011; // Stay in Stop state
                end
            end
        endcase
    end
end

endmodule