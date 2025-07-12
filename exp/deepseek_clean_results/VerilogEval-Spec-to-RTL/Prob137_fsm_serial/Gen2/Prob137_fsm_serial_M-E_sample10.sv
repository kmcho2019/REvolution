module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

    reg [10:0] frame_reg;  // Holds start(1b) + data(8b) + stop(1b)
    reg [3:0] shift_count; // Counts 0-10 (11 bits total)
    reg valid_frame;
    reg receiving;

    always @(posedge clk) begin
        if (reset) begin
            frame_reg <= 11'b0;
            shift_count <= 4'b0;
            valid_frame <= 1'b0;
            receiving <= 1'b0;
        end else begin
            // Default assignments
            valid_frame <= 1'b0;

            if (receiving) begin
                // Shift in new bit
                frame_reg <= {in, frame_reg[10:1]};
                shift_count <= shift_count + 1;

                // Check for complete frame
                if (shift_count == 4'd10) begin
                    receiving <= 1'b0;
                    // Validate start (bit10=0) and stop (bit0=1)
                    if (frame_reg[10] == 1'b0 && in == 1'b1) begin
                        valid_frame <= 1'b1;
                    end
                end
            end else begin
                // Look for start bit (falling edge)
                if (in == 1'b0) begin
                    receiving <= 1'b1;
                    shift_count <= 4'b0;
                    frame_reg <= 11'b0;
                end
            end
        end
    end

    assign done = valid_frame;

endmodule