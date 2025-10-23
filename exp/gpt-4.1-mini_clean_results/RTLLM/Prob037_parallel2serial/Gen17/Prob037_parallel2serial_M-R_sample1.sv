module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output       dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    // MSB of data is the serial output
    assign dout = data[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'd0;
            cnt       <= 2'd0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                data      <= d;      // load new parallel data
                cnt       <= 2'd0;  // reset counter
                valid_out <= 1'b1;  // valid on new data load (MSB output)
            end else begin
                data      <= {data[2:0], 1'b0}; // shift left, MSB out as dout
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule