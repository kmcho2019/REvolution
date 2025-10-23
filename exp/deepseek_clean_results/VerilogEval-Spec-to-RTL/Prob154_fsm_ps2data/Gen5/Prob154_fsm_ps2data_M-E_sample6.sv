module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [23:0] shift_reg;
    reg [1:0] byte_counter;
    wire next_done;

    // Combinational done calculation
    assign next_done = (byte_counter == 2'd2);

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 24'b0;
            byte_counter <= 2'b0;
            done <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;

            if (byte_counter == 2'b0) begin
                // IDLE state - wait for start byte
                if (in[3]) begin
                    shift_reg <= {in, 16'b0};
                    byte_counter <= 2'b1;
                end
            end else begin
                // Shift in new byte
                shift_reg <= {shift_reg[15:0], in};
                
                if (next_done) begin
                    // Message complete
                    out_bytes <= {shift_reg[23:16], shift_reg[15:8], in};
                    done <= 1'b1;
                    byte_counter <= 2'b0;
                end else begin
                    // Continue collecting bytes
                    byte_counter <= byte_counter + 1'b1;
                end
            end
        end
    end

endmodule