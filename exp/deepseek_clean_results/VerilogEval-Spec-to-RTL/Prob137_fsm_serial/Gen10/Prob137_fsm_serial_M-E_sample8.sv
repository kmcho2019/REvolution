module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    reg [3:0] counter;  // Counts 0-10 (start + 8 data + stop)
    reg [7:0] data_reg;
    reg done_reg;
    wire is_idle = counter[3];  // Counter > 10 means idle (since it's 4-bit)

    always @(posedge clk) begin
        if (reset) begin
            counter <= 4'b1000;  // Initialize to idle (8-15)
            done_reg <= 1'b0;
        end else begin
            done_reg <= 1'b0;

            if (is_idle) begin
                if (~in) begin  // Start bit detected
                    counter <= 4'b0;
                end
            end else begin
                counter <= counter + 1;

                if (counter == 4'b1000) begin  // After 8 data bits (position 8)
                    data_reg <= {in, data_reg[7:1]};  // Capture all bits
                end

                if (counter == 4'b1001) begin  // Stop bit position
                    if (in) begin  // Valid stop
                        done_reg <= 1'b1;
                        counter <= 4'b1000;  // Return to idle
                    end else begin
                        counter <= 4'b1001;  // Stay until stop bit arrives
                    end
                end
            end
        end
    end

    assign done = done_reg;

endmodule