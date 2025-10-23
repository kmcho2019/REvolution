module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;      // Binary counter (0-3)
    reg [3:0] data_reg;
    
    // Counter logic - increments on each clock
    wire [1:0] next_cnt = (cnt == 2'b11) ? 2'b00 : (cnt + 1'b1);
    
    // Shift register output - always outputs MSB
    assign dout = data_reg[3];
    
    // Valid when counter is 0 (first bit of new data)
    assign valid_out = (cnt == 2'b00);
    
    // Update registers on clock edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            data_reg <= 4'b0;
        end else begin
            cnt <= next_cnt;
            if (cnt == 2'b11) begin
                data_reg <= d;       // Load new data at end of cycle
            end else begin
                data_reg <= {data_reg[2:0], 1'b0};  // Shift left
            end
        end
    end

endmodule