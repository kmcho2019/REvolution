module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data_reg;
    reg [1:0] cnt;

    // Output the MSB of the data_reg, then shift data_reg left by 1 bit each cycle
    assign dout = data_reg[3];

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt       <= 2'b0;
            data_reg  <= 4'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd0) begin
                // Load new parallel data at start of serialization
                data_reg  <= d;
                valid_out <= 1'b1;  // valid for entire serialization period
            end else begin
                // Shift left to move next bit into MSB position
                data_reg <= {data_reg[2:0], 1'b0};
                valid_out <= 1'b1;
            end

            // Increment counter modulo 4
            if (cnt == 2'd3) 
                cnt <= 2'b0;
            else
                cnt <= cnt + 1'b1;
        end
    end

endmodule