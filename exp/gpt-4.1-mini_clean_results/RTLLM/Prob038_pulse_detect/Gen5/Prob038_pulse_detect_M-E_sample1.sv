module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // Shift register to hold previous two data_in samples
    reg [1:0] shift;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift    <= 2'b11;    // Initialize to a value not matching the pattern
            data_out <= 1'b0;
        end else begin
            // Shift in new sample
            shift <= {shift[0], data_in};

            // Detect pattern: shift[1]=0, shift[0]=1, data_in=0
            if (shift == 2'b01 && data_in == 1'b0)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule