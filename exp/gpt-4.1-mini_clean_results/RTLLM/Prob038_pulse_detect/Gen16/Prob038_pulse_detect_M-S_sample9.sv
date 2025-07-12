module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    reg data_in_d;
    reg pulse_started;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_in_d    <= 1'b0;
            data_out     <= 1'b0;
            pulse_started <= 1'b0;
        end else begin
            data_out <= 1'b0;  // default no pulse output

            // detect rising edge
            if (~data_in_d & data_in) begin
                pulse_started <= 1'b1;
            end

            // detect falling edge after rising edge
            if (data_in_d & ~data_in & pulse_started) begin
                data_out <= 1'b1;   // pulse detected
                pulse_started <= 1'b0;
            end

            data_in_d <= data_in;
        end
    end

endmodule