module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;          // 2-bit binary counter (0-3)
    reg [3:0] data_reg;     // Data storage register
    reg [1:0] ptr;          // Circular buffer pointer

    // Combinational next state logic
    wire [1:0] next_cnt = (cnt == 2'b11) ? 2'b00 : cnt + 1'b1;
    wire load_data = (cnt == 2'b11);
    wire [1:0] next_ptr = load_data ? 2'b0 : ptr + 1'b1;

    // Output assignments
    assign dout = data_reg[3-ptr];  // MSB first (ptr 0->3)
    assign valid_out = ~load_data;  // Valid when not loading

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            ptr <= 2'b00;
            data_reg <= 4'b0;
        end else begin
            cnt <= next_cnt;
            ptr <= next_ptr;
            
            if (load_data) begin
                data_reg <= d;  // Load new parallel data
            end
        end
    end

endmodule