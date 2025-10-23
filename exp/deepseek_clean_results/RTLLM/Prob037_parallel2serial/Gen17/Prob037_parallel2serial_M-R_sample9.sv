module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;
    reg [3:0] data_reg;

    // Binary counter increment
    wire [1:0] next_cnt = (cnt == 2'b11) ? 2'b00 : cnt + 1'b1;

    // Barrel shifter output selection
    wire [3:0] next_data = (cnt == 2'b11) ? d : data_reg;
    assign dout = data_reg[3-cnt];

    // Valid generation (combinational)
    assign valid_out = (cnt == 2'b00);

    // Register updates
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            data_reg <= 4'b0;
        end else begin
            cnt <= next_cnt;
            data_reg <= next_data;
        end
    end

endmodule