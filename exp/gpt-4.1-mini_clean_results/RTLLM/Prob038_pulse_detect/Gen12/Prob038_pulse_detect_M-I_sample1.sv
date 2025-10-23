module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // Shift register holds data_in sampled at previous two clock cycles
    reg [1:0] shift; 

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift    <= 2'b00;
            data_out <= 1'b0;
        end else begin
            // Shift in current data_in
            shift <= {shift[0], data_in};

            // Detect pulse pattern "0 -> 1 -> 0" across three cycles:
            // shift[1]: t-2 cycle input
            // shift[0]: t-1 cycle input
            // data_in : current cycle input (t)
            // data_out asserted for one cycle at end of pulse
            if ((shift == 2'b01) && (data_in == 1'b0))
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule