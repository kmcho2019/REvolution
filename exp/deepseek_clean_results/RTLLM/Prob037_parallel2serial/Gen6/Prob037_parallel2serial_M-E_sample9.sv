module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [3:0] data_reg;
    reg [1:0] cnt;
    
    // Pre-compute all possible shifted versions
    wire [3:0] shifted_0 = data_reg;
    wire [3:0] shifted_1 = {data_reg[2:0], 1'b0};
    wire [3:0] shifted_2 = {data_reg[1:0], 2'b0};
    wire [3:0] shifted_3 = {data_reg[0], 3'b0};
    
    // Mux to select current output bit
    wire [3:0] current_shift = (cnt == 2'b00) ? shifted_0 :
                              (cnt == 2'b01) ? shifted_1 :
                              (cnt == 2'b10) ? shifted_2 : shifted_3;
    
    // Output assignments
    assign dout = current_shift[3];
    assign valid_out = (cnt == 2'b00);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg <= 4'b0;
            cnt <= 2'b0;
        end else begin
            if (cnt == 2'b11) begin
                // Load new data and reset counter
                data_reg <= d;
                cnt <= 2'b00;
            end else begin
                // Just increment counter
                cnt <= cnt + 1;
            end
        end
    end

endmodule