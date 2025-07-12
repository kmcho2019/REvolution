module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    parameter WIDTH = 8;
    
    reg [WIDTH-1:0] shift_reg;
    reg [WIDTH-1:0] shift_reg_next;
    
    // Clock gating for shift register
    always @(*) begin
        if (din_valid) begin
            shift_reg_next = {shift_reg[WIDTH-2:0], din_serial};
        end else begin
            shift_reg_next = shift_reg;
        end
    end
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= {WIDTH{1'b0}};
            dout_parallel <= {WIDTH{1'b0}};
            dout_valid <= 1'b0;
        end
        else begin
            shift_reg <= shift_reg_next;
            
            // Output and valid generation
            dout_valid <= 1'b0;
            if (din_valid && (&shift_reg[WIDTH-2:0])) begin
                dout_parallel <= {shift_reg[WIDTH-2:0], din_serial};
                dout_valid <= 1'b1;
            end
        end
    end

endmodule