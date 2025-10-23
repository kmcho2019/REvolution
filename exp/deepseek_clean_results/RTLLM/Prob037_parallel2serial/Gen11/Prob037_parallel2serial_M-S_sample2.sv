module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;
    reg [3:0] data;
    
    // Bit selection using counter
    assign dout = data[3-cnt];
    assign valid_out = (cnt == 2'b00);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b0;
            data <= 4'b0;
        end else begin
            if (cnt == 2'b11) begin
                // Load new data and reset counter
                data <= d;
                cnt <= 2'b0;
            end else begin
                // Increment counter
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule