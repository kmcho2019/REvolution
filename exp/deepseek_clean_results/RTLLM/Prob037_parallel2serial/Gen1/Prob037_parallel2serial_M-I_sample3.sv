module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] data;     // Shift register to hold parallel data
    reg [1:0] cnt;      // 2-bit counter (0-3)
    reg load;           // Control signal for loading new data

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            data <= 4'b0;
            cnt <= 2'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
            load <= 1'b1;  // Ready to load new data
        end
        else begin
            if (load) begin
                // Load new parallel data
                data <= d;
                valid_out <= 1'b1;
                load <= 1'b0;
            end
            else begin
                // Shift operation
                data <= {data[2:0], 1'b0};  // Logical left shift
                cnt <= cnt + 1'b1;
                
                if (cnt == 2'b11) begin
                    load <= 1'b1;  // Ready to load new data next cycle
                end
            end
            
            // Output MSB of shift register
            dout <= data[3];
        end
    end

endmodule