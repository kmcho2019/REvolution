module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;          // 2-bit binary counter (0-3)
    reg [3:0] data_reg;     // Data register holds parallel input

    // Output assignments
    assign dout = data_reg[3-cnt];  // MSB first, then descending
    assign valid_out = (cnt != 2'b11); // Valid for first 3 cycles (0,1,2)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b0;
            data_reg <= 4'b0;
        end else begin
            if (cnt == 2'b11) begin
                // Load new data and reset counter
                data_reg <= d;
                cnt <= 2'b0;
            end else begin
                // Increment counter
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule