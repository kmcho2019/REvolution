module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    reg [2:0] cnt;          // 3-bit counter (0-7)
    reg [7:0] shift_reg;    // 8-bit shift register
    wire [7:0] next_shift;  // Next shift register value
    wire [2:0] next_cnt;    // Next counter value
    wire output_ready;      // Combinational output ready signal

    // Combinational logic
    assign next_shift = din_valid ? {shift_reg[6:0], din_serial} : shift_reg;
    assign next_cnt = (!rst_n) ? 3'b0 : 
                     (din_valid && cnt == 3'd7) ? 3'b0 :
                     din_valid ? cnt + 1'b1 : cnt;
    assign output_ready = (cnt == 3'd7) && din_valid;
    assign dout_valid = output_ready;

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'b0;
            shift_reg <= 8'b0;
            dout_parallel <= 8'b0;
        end
        else begin
            // Update shift register
            shift_reg <= next_shift;
            
            // Update counter
            cnt <= next_cnt;
            
            // Capture parallel output when ready
            if (output_ready) begin
                dout_parallel <= next_shift;
            end
        end
    end

endmodule