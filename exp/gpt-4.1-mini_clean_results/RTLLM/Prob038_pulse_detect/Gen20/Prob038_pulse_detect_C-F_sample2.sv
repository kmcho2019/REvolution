module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    reg [1:0] shift;
    reg       data_in_d;

    // Sample data_in synchronously and update shift register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift     <= 2'b00;
            data_in_d <= 1'b0;
        end else begin
            data_in_d <= data_in;
            shift     <= {shift[0], data_in_d};
        end
    end

    // Combinational output: detect 0->1->0 pattern over 3 cycles,
    // that is when previous two bits are "01" and current data_in_d is 0
    always @(*) begin
        data_out = (shift == 2'b01) && (data_in_d == 1'b0);
    end

endmodule