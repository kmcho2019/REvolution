module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            data <= 4'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Output last bit of current data
                dout <= data[3];
                valid_out <= 1'b1;
                // Load new data and reset counter
                data <= d;
                cnt <= 2'b0;
            end else begin
                // Output MSB of current data
                dout <= data[3];
                // valid_out high only on first bit output, i.e., cnt==0
                valid_out <= (cnt == 2'd0) ? 1'b1 : 1'b0;
                // Shift data left circularly (MSB to LSB)
                data <= {data[2:0], data[3]};
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule