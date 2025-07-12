module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [3:0] data_reg;
    reg [1:0] ptr;  // Rotating pointer (0-3)
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg <= 4'b0;
            ptr <= 2'b0;
        end else begin
            if (ptr == 2'b11) begin
                data_reg <= d;      // Load new data at wrap-around
                ptr <= 2'b0;
            end else begin
                ptr <= ptr + 1;    // Increment pointer
            end
        end
    end

    // Dynamic bit selection using rotating pointer
    assign dout = data_reg[3-ptr];  // MSB first (ptr=0 selects bit3)
    assign valid_out = (ptr == 2'b0); // Valid when pointing to MSB

endmodule