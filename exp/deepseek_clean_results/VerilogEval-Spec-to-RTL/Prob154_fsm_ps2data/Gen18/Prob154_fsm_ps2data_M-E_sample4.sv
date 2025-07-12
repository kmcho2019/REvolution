module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] byte_counter;
    reg [23:0] shift_reg;
    reg next_done;

    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'b00;
            shift_reg <= 24'bx;
            done <= 1'b0;
        end else begin
            // Update done signal from pre-calculation
            done <= next_done;

            // Shift register and counter logic
            if (byte_counter == 2'b00) begin
                if (in[3]) begin
                    shift_reg <= {in, 16'bx}; // Store first byte
                    byte_counter <= 2'b01;
                end
            end else begin
                shift_reg <= {shift_reg[15:0], in}; // Shift in new byte
                byte_counter <= byte_counter + 1'b1;
            end

            // Output gating - only update when done will be asserted
            if (next_done) begin
                out_bytes <= {shift_reg[23:16], shift_reg[15:8], in};
            end
        end
    end

    // Pre-calculate done signal
    always @(*) begin
        next_done = (byte_counter == 2'b10);
    end

endmodule