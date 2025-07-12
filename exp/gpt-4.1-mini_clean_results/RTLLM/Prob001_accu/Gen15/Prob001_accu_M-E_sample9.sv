module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0] data_regs [0:3];    // shift register holding 4 inputs
    reg [1:0] count;              // count number of valid inputs received (0 to 4)
    reg       output_stage;       // flag indicating output cycle
    
    integer i;
    
    // combinational sum of four 8-bit registers
    wire [9:0] sum;
    assign sum = data_regs[0] + data_regs[1] + data_regs[2] + data_regs[3];
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 4; i = i + 1) begin
                data_regs[i] <= 8'd0;
            end
            count       <= 2'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
            output_stage<= 1'b0;
        end else begin
            valid_out <= 1'b0;
            
            if (output_stage) begin
                // output the sum of 4 inputs collected previously
                data_out  <= sum;
                valid_out <= 1'b1;
                count     <= 2'd0;
                output_stage <= 1'b0;
                // do not shift in new data this cycle, wait for next valid_in
            end else begin
                if (valid_in) begin
                    // shift in new data
                    data_regs[0] <= data_in;
                    data_regs[1] <= data_regs[0];
                    data_regs[2] <= data_regs[1];
                    data_regs[3] <= data_regs[2];
                    if (count == 2'd3) begin
                        // 4th data collected, schedule output next cycle
                        output_stage <= 1'b1;
                    end else begin
                        count <= count + 1'b1;
                    end
                end
                // if valid_in is 0 and not output stage, keep data_regs and count unchanged
            end
        end
    end

endmodule