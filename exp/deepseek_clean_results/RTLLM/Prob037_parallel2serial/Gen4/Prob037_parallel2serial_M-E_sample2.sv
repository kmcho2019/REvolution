module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    // One-hot control register (circular shift)
    reg [3:0] ctrl = 4'b0001;
    // Data storage register
    reg [3:0] data;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            ctrl <= 4'b0001;
            data <= 4'b0;
            dout <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            // Circular shift the control register
            ctrl <= {ctrl[2:0], ctrl[3]};
            
            // Update data and valid_out when starting new conversion
            if (ctrl[3]) begin
                data <= d;
                valid_out <= 1'b1;
            end else begin
                valid_out <= 1'b0;
            end
            
            // Bit selection using the control register
            case (ctrl)
                4'b0001: dout <= data[0];
                4'b0010: dout <= data[1];
                4'b0100: dout <= data[2];
                4'b1000: dout <= data[3];
                default: dout <= 1'b0;
            endcase
        end
    end

endmodule