module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [1:0] cnt;
    reg [3:0] data_reg;

    // Output is MSB of data_reg (serialized MSB to LSB)
    assign dout = data_reg[3];

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt       <= 2'd0;
            data_reg  <= 4'd0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd0) begin
                // Load new parallel data, output MSB, assert valid_out
                data_reg  <= d;
                valid_out <= 1'b1;
                cnt       <= cnt + 1'b1;
            end else begin
                // Shift left to move next bit into MSB position
                data_reg  <= {data_reg[2:0], 1'b0};
                valid_out <= 1'b0;
                if (cnt == 2'd3)
                    cnt <= 2'd0; // Reset counter after last bit
                else
                    cnt <= cnt + 1'b1;
            end
        end
    end

endmodule