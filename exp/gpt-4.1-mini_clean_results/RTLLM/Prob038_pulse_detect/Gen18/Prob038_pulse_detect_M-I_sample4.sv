module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output wire data_out
);

    reg [1:0] shift;

    wire shift_enable = (data_in != shift[0]); // Update only when data_in changes

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            shift <= 2'b00;
        else if (shift_enable)
            shift <= {shift[0], data_in};
        // else retain previous shift value to reduce toggling
    end

    assign data_out = (shift == 2'b01) && (data_in == 1'b0);

endmodule