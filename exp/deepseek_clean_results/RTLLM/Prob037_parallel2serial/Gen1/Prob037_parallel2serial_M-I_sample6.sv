module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] data;     // Shift register to hold parallel data
    reg [1:0] cnt;      // 2-bit counter (0-3)
    reg active;         // Conversion in progress flag

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            data <= 4'b0;
            cnt <= 2'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
            active <= 1'b0;
        end
        else begin
            if (cnt == 2'b00) begin
                // First cycle - load new parallel data
                data <= d;
                valid_out <= 1'b1;
                active <= 1'b1;
            end
            else if (cnt == 2'b11) begin
                // Last cycle - prepare for next load
                active <= 1'b0;
            end

            // Output current MSB
            dout <= data[3];
            
            // Shift left (MSB first)
            data <= {data[2:0], 1'b0};
            
            // Update counter
            cnt <= active ? (cnt + 1'b1) : 2'b00;
        end
    end

endmodule