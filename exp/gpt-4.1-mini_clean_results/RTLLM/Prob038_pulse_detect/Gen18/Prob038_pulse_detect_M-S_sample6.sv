module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    reg data_in_d;
    reg pulse_flag;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_in_d  <= 1'b0;
            pulse_flag <= 1'b0;
            data_out   <= 1'b0;
        end else begin
            data_in_d <= data_in;
            data_out  <= 1'b0; // default

            // Rising edge detection: 0->1
            if (~data_in_d & data_in)
                pulse_flag <= 1'b1;

            // Falling edge detection: 1->0 and pulse_flag is set
            else if (data_in_d & ~data_in & pulse_flag) begin
                data_out  <= 1'b1; // pulse detected at end
                pulse_flag <= 1'b0;
            end
        end
    end

endmodule