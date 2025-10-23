module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;          // 2-bit binary counter (0-3)
    reg [3:0] data_reg;     // Data storage register
    reg load_flag;          // Flag to indicate when to load new data

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            load_flag <= 1'b1;
        end else begin
            if (cnt == 2'b11) begin
                cnt <= 2'b00;
                load_flag <= 1'b1;
            end else begin
                cnt <= cnt + 1'b1;
                load_flag <= 1'b0;
            end
        end
    end

    // Data register logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg <= 4'b0;
        end else if (load_flag) begin
            data_reg <= d;
        end
    end

    // Output logic (combinational)
    assign dout = data_reg[3 - cnt];  // Circular buffer access
    assign valid_out = ~load_flag;    // Valid when not loading new data

endmodule