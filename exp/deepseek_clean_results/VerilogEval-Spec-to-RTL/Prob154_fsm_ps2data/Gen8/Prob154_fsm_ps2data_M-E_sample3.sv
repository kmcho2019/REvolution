module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    reg [23:0] shift_reg;
    reg [1:0] byte_counter;
    wire collecting;

    // Combinational logic for done signal
    assign done = (byte_counter == 2'b10) && !reset;

    // Determine if we're currently collecting a message
    assign collecting = |byte_counter;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 24'bx;  // Don't-care during reset
            byte_counter <= 2'b00;
            out_bytes <= 24'bx;
        end else begin
            // Default assignments
            out_bytes <= 24'bx;

            if (collecting) begin
                // Shift in new byte and increment counter
                shift_reg <= {shift_reg[15:0], in};
                byte_counter <= byte_counter + 1'b1;

                // Capture output when done
                if (done) begin
                    out_bytes <= {shift_reg[15:0], in};
                    byte_counter <= 2'b00;  // Reset counter
                end
            end else if (in[3]) begin
                // Start new message collection
                shift_reg <= {16'b0, in};
                byte_counter <= 2'b01;
            end
        end
    end

endmodule