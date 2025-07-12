module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    reg [2:0] counter;
    reg [7:0] shift_reg;
    
    // Continuous assignment for output valid
    assign dout_valid = (counter == 3'd7) & din_valid;
    
    // Shift register implementation
    always @(posedge clk) begin
        if (!rst_n) begin
            shift_reg <= 8'b0;
        end
        else if (din_valid) begin
            shift_reg <= {shift_reg[6:0], din_serial};
        end
    end
    
    // Counter and parallel output logic
    always @(posedge clk) begin
        if (!rst_n) begin
            counter <= 3'b0;
            dout_parallel <= 8'b0;
        end
        else if (din_valid) begin
            if (counter == 3'd7) begin
                counter <= 3'b0;
                dout_parallel <= {shift_reg[6:0], din_serial};
            end
            else begin
                counter <= counter + 1'b1;
            end
        end
    end

endmodule