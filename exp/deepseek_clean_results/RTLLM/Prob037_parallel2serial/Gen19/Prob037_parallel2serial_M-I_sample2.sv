module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;          // Binary counter (0-3)
    reg [3:0] data_reg;     // Data register
    reg load_flag;          // Load control flag

    // Output assignments
    assign dout = data_reg[3-cnt];  // Direct bit selection
    assign valid_out = (cnt != 2'b11); // Valid except during load cycle

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b11;    // Initialize to load state
            data_reg <= 4'b0;
            load_flag <= 1'b1;
        end else begin
            if (cnt == 2'b11) begin
                // Load new data
                data_reg <= d;
                cnt <= 2'b00;
                load_flag <= 1'b0;
            end else begin
                // Increment counter
                cnt <= cnt + 1'b1;
                load_flag <= 1'b0;
            end
        end
    end

endmodule