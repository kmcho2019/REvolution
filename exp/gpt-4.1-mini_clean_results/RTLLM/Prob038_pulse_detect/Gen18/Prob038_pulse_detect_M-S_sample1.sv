module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    reg [1:0] shift;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift    <= 2'b00;
            data_out <= 1'b0;
        end else begin
            shift <= {shift[0], data_in};
            // pulse detected when pattern is 0 (oldest), 1 (middle), 0 (current)
            data_out <= (shift == 2'b01) && (data_in == 1'b0);
        end
    end

endmodule