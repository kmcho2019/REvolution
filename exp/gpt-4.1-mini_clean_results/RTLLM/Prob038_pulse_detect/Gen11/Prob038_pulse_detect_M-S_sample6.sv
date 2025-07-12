module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    reg [1:0] shift; // holds data_in delayed by 1 and 2 cycles

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift    <= 2'b00;
            data_out <= 1'b0;
        end else begin
            // shift in current data_in
            shift <= {shift[0], data_in};
            // check for pattern 0 (t-2), 1 (t-1), 0 (t)
            // t: current data_in
            // t-1: shift[0]
            // t-2: shift[1]
            data_out <= (shift == 2'b01) && (data_in == 1'b0);
        end
    end

endmodule