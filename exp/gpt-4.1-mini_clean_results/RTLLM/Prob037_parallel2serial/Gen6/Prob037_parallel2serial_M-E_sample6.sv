module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    // On each cycle, output the bit indexed by cnt (MSB to LSB)
    assign dout = data[cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'd3;   // Start counting from MSB
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd0) begin
                // LSB has been output, load new parallel data and reset count to MSB
                data      <= d;
                cnt       <= 2'd3;
                valid_out <= 1'b1; // MSB valid next cycle when cnt=3
            end else begin
                // Decrement counter to move from MSB to LSB
                cnt       <= cnt - 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule