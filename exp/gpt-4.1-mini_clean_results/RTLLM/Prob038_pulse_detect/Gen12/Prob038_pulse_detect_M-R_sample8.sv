module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    reg [1:0] shift;

    // Sequential logic: update shift register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift <= 2'b00;
        end else begin
            shift <= {shift[0], data_in};
        end
    end

    // Combinational logic: detect pulse pattern 0->1->0 over three samples
    wire pulse_detected = (shift == 2'b01) && (data_in == 1'b0);

    // Sequential logic: register output pulse for one cycle
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 1'b0;
        end else begin
            data_out <= pulse_detected;
        end
    end

endmodule