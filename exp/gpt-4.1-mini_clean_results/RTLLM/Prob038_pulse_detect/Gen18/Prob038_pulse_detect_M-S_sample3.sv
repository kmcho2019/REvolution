module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output wire data_out
);

    reg [1:0] shift;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            shift <= 2'b00;
        else
            shift <= {shift[0], data_in};
    end

    assign data_out = (shift == 2'b01) && (data_in == 1'b0);

endmodule