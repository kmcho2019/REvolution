module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output wire dout
);

    reg [3:0] data_reg;
    reg [1:0] pos_counter;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg <= 4'b0;
            pos_counter <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            if (pos_counter == 2'b11) begin
                // Load new data at end of cycle
                data_reg <= d;
                pos_counter <= 2'b0;
                valid_out <= 1'b1;
            end else begin
                // Rotate data and increment counter
                data_reg <= {data_reg[2:0], data_reg[3]};
                pos_counter <= pos_counter + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

    // MSB is always the output
    assign dout = data_reg[3];

endmodule