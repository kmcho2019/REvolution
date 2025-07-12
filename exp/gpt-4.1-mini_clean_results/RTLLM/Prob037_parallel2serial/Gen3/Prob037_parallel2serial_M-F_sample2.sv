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
            if (cnt == 2'b0) begin
                data      <= d;       // Load new input data at the start of transmission
                valid_out <= 1'b1;    // Valid output asserted for all 4 bits
                dout      <= d[3];    // Output MSB first
                cnt       <= cnt + 1; // Move to next bit
            end else if (cnt < 2'd4) begin
                data      <= {data[2:0], 1'b0}; // Shift left to bring next bit to MSB
                dout      <= data[2];             // Output next MSB (before shift it was data[3], now data[2])
                valid_out <= 1'b1;                // Maintain valid signal high during entire transmission
                cnt       <= cnt + 1;
            end else begin
                // After 4 bits output, reset counter to 0 to load new data next cycle
                cnt       <= 2'b0;
                valid_out <= 1'b0; // No valid data outside serialization window
                dout      <= 1'b0;
            end
        end
    end

endmodule