module parallel2serial(
    input  wire       clk,
    input  wire       rst_n,
    input  wire [3:0] d,
    output reg        valid_out,
    output reg        dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'b11;  // so on first increment goes to 0, load data
            data      <= 4'b0;
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            if (cnt == 2'b11) begin
                data      <= d;
                cnt       <= 2'b0;
                valid_out <= 1'b1;
                dout      <= d[3];
            end else begin
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
                data      <= {data[2:0], 1'b0}; // shift left by 1 bit
                dout      <= data[2]; // next bit to output after MSB
            end
        end
    end

endmodule