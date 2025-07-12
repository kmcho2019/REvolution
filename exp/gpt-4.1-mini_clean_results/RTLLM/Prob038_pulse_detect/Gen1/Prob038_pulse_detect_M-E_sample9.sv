module pulse_detect (
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg data_out
);

    reg data_in_d1, data_in_d2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_in_d1 <= 1'b0;
            data_in_d2 <= 1'b0;
            data_out <= 1'b0;
        end else begin
            // Shift data_in samples
            data_in_d2 <= data_in_d1;
            data_in_d1 <= data_in;

            // Detect pulse pattern: previous=0, current=1, next=0
            // That is, at cycle N: data_in_d2=0 (N-2), data_in_d1=1 (N-1), data_in=0 (N)
            if (data_in_d2 == 1'b0 && data_in_d1 == 1'b1 && data_in == 1'b0)
                data_out <= 1'b1;  // Pulse detected at current cycle
            else
                data_out <= 1'b0;
        end
    end

endmodule