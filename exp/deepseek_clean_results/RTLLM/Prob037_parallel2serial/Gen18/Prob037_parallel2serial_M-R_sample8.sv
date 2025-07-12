module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;          // 2-bit binary counter (0-3)
    reg [3:0] data_reg;     // Data storage register
    wire [1:0] next_cnt;    // Next counter value
    wire load_data;         // Control signal for loading new data

    // Combinational next state logic
    assign next_cnt = (cnt == 2'b11) ? 2'b00 : cnt + 1'b1;
    assign load_data = (cnt == 2'b11);

    // Output assignments
    assign valid_out = load_data;
    assign dout = data_reg[3];  // Always output MSB

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            data_reg <= 4'b0;
        end else begin
            // Update counter
            cnt <= next_cnt;
            
            // Update data register
            if (load_data) begin
                data_reg <= d;          // Load new data
            end else begin
                data_reg <= {data_reg[2:0], 1'b0};  // Shift left
            end
        end
    end

endmodule