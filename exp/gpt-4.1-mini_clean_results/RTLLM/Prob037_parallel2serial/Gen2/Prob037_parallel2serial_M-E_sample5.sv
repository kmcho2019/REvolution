module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output reg   dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'b0;
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                data      <= d;        // Load new parallel input at end of serialization
                cnt       <= 2'b0;     // Reset counter to start new transmission
                valid_out <= 1'b1;     // Valid for new 4-cycle transmission starting now
                dout      <= d[3];     // Output MSB of newly loaded data
            end else begin
                data      <= {data[2:0], 1'b0}; // Shift left by 1 bit, MSB moves out to dout
                cnt       <= cnt + 1'b1;        // Increment counter
                valid_out <= 1'b1;              // Valid remains high during entire 4-bit output
                dout      <= data[3];           // Output current MSB of shifted data
            end
        end
    end

endmodule