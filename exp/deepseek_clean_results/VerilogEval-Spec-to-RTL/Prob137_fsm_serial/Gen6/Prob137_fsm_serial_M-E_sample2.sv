module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    reg [9:0] frame_reg;  // Stores start + 8 data + stop bits
    reg [3:0] bit_counter;
    reg receiving;
    reg in_prev;

    // Edge detection for start bit
    wire start_edge = (in_prev == 1'b1) && (in == 1'b0);

    always @(posedge clk) begin
        if (reset) begin
            frame_reg <= 10'b0;
            bit_counter <= 4'b0;
            receiving <= 1'b0;
            done <= 1'b0;
            in_prev <= 1'b1;
        end else begin
            in_prev <= in;
            
            // Start reception on falling edge (start bit)
            if (!receiving && start_edge) begin
                receiving <= 1'b1;
                bit_counter <= 4'b0;
                frame_reg <= {9'b0, in};  // Capture start bit
            end
            
            // Shift in data while receiving
            if (receiving) begin
                frame_reg <= {in, frame_reg[9:1]};
                bit_counter <= bit_counter + 1;
                
                // Complete when all bits received
                if (bit_counter == 4'd9) begin
                    receiving <= 1'b0;
                    // Validate frame (start=0, stop=1)
                    done <= (frame_reg[9] == 1'b0) && (in == 1'b1);
                end else begin
                    done <= 1'b0;
                end
            end else begin
                done <= 1'b0;
            end
        end
    end

endmodule