module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    reg [1:0] data_shift; // stores data_in from previous two cycles

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_shift <= 2'b00;
            data_out   <= 1'b0;
        end else begin
            data_shift <= {data_shift[0], data_in};
            // Detect pattern: previous two inputs were 0 then 1, current input is 0
            data_out <= (data_shift == 2'b01) && (data_in == 1'b0);
        end
    end

endmodule