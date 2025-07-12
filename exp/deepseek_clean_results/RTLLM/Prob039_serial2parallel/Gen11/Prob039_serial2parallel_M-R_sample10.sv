module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    reg [3:0] counter;  // Counts 0-8 (needs 4 bits)

    // Continuous valid signal (combinational)
    assign dout_valid = (counter == 4'd8);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
            counter <= 4'b0;
        end
        else begin
            if (din_valid) begin
                if (counter < 4'd8) begin
                    // Shift in new bit (MSB first)
                    dout_parallel <= {dout_parallel[6:0], din_serial};
                    counter <= counter + 1'b1;
                end
                
                // Auto-reset when reaching 8
                if (counter == 4'd8) begin
                    counter <= 4'b0;
                end
            end
        end
    end

endmodule